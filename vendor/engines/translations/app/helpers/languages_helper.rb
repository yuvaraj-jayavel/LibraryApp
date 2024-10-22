module LanguagesHelper
  # Set the I18n.locale either from member or cookie
  # TODO Test for helper
  def set_locale_from_cookie_or_member
    if wob_member
      locale = Language.for_member(wob_member, @current_program)
      I18n.locale = locale
      # We also set the locale in the cookie, because we need to retain the locale, even when the user has logged out of the site.
      store_locale_to_cookie(locale)
    else
      I18n.locale = current_locale
    end
  end

  # Returns the current locale either from
  def current_locale(options = {from_non_org: false})
    if wob_member
      Language.for_member(wob_member, @current_program)
    else
      new_locale = cookies[:current_locale]
      (valid_locale?(new_locale, super_console?, wob_member, program_context, from_non_org: options[:from_non_org]) ? new_locale : I18n.default_locale.to_s).to_sym
    end
  end

  def store_locale_to_cookie(value, options = {from_non_org: false})
    cookies[:current_locale] =
      if valid_locale?(value, super_console?, wob_member, program_context, from_non_org: options[:from_non_org])
        value.to_s
      else
        I18n.default_locale.to_s
      end
  end

  def store_locale_to_member(value)
    if valid_locale?(value, super_console?, wob_member, program_context)
      if wob_member
        Language.set_for_member(wob_member, value)
      end
    end
  end

  def get_available_languages(from_non_org: false)
    return [] if !from_non_org && !(current_organization.active? && current_organization.language_settings_enabled?)

    current_language = Language.find_by(language_name: current_locale(from_non_org: from_non_org).to_s)
    english_language = Language.for_english
    current_language = english_language if valid_locale?(current_language, super_console?, wob_member, program_context, from_non_org: false)
    other_languages  = Language.supported_for(super_console?, wob_member, program_context, from_non_org: from_non_org)

    build_languages_for_view(Array(current_language).concat([english_language]).concat(other_languages).uniq, from_non_org)
  end

  def get_available_for_string(locale)
    if locale.in?(END_USER_ONLY_LOCALES)
      "feature.language.manage_page.content.availability_status.Only_End_users".translate
    else
      "feature.language.manage_page.content.availability_status.Everyone".translate
    end
  end

  def get_language_selection_redirect_path
    request.get? ? request.fullpath : ''
  end

  private

  def valid_locale?(value, is_super_console, wob_member, abstract_program, options = {from_non_org: false})
    return false if value.nil?
    Language.valid_locale?(value, is_super_console, wob_member, abstract_program, from_non_org: options[:from_non_org])
  end

  def build_languages_for_view(languages, from_non_org)
    unless from_non_org
      language_id_to_org_language =
        OrganizationLanguage.unscoped.
          where(organization_id: current_organization.id, language_id: languages.reject(&:default?).map(&:id)).index_by(&:language_id)
    end

    languages.map.with_index do |language, index|
      title_with_display_title = language_id_to_org_language.try(:[], language.id)&.to_display(language_title: language.title) || language.to_display
      language_options = { language_name: language.language_name }
      if index.zero? # First element
        language_options[:title_for_display] = (language_id_to_org_language.try(:[], language.id) || language).title
        language_options[:tooltip] = title_with_display_title
      end
      language_options.reverse_merge!(title_for_display: title_with_display_title)
      language_options
    end
  end
end