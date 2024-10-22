class Language < ApplicationRecord
  include FedRampExcludable
  include HasEsReindexFollowups

  TITLE_ENGLISH = 'English'
  MASS_UPDATE_ATTRIBUTES = {
    create: [:title, :display_title, :language_name, :enabled],
    update: [:title, :display_title, :language_name, :enabled]
  }

  has_many :organization_languages, dependent: :destroy
  has_many :member_languages, dependent: :delete_all

  validates :title, :display_title, presence: true
  validates :language_name, presence: true, uniqueness: { case_sensitive: true }, exclusion: { in: [I18n.default_locale.to_s] }
  sanitize_fields text_fields: [:title, :display_title, language_name: { uniqueness: true }]

  scope :ordered, -> { order(:title) }
  scope :enabled, -> { where(enabled: true) }

  after_update :sync_language_name_with_organization_language

  register_es_reindex_followup ["User", "Member"], on: :update, if: :saved_change_to_title?

  def self.for_member(member, program = nil)
    member_language = member.member_language
    return I18n.default_locale unless member_language

    member_language_name = member_language.language.language_name
    return member_language_name.to_sym if member.admin?
    enabled_languages = program ? program.program_languages.enabled_for_all.map(&:organization_language) : member.organization.organization_languages.enabled
    enabled_languages.collect(&:language_name).include?(member_language_name) ? member_language_name.to_sym : I18n.default_locale
  end

  def self.set_for_member(member, language_name)
    if language_name.to_s == I18n.default_locale.to_s
      member.member_language.try(:destroy)
    else
      language = self.find_by(language_name: language_name)
      member_language = (member.member_language || member.build_member_language)
      member_language.language = language
      member_language.save!
    end
  end

  # language_name => Value of the locale ex: 'en'
  # program_or_org => Either program or organization
  # include_all_languages => true/false. Super Admins might want to play with even disabled languages.
  def self.valid_locale?(value, is_super_console, member, abstract_program, options = { from_non_org: false } )
    return true if value.to_s == I18n.default_locale.to_s
    return true if options[:from_non_org] && Language.enabled.collect(&:language_name).include?(value.to_s)
    return false unless is_super_console || abstract_program.try(:get_organization).try(:language_settings_enabled?)
    return self.supported_for(is_super_console, member, abstract_program, options).map(&:language_name).include?(value.to_s)
  end

  def self.supported_for(is_super_console, member, abstract_program, options = {})
    organization = abstract_program.try(:get_organization)

    supported_languages =
      if is_super_console
        Language.all
      elsif options[:from_non_org]
        Language.enabled
      elsif organization.try(:language_settings_enabled?)
        if member.blank? || member.programs.empty?
          Language.enabled.where(id: organization.organization_languages.enabled.select(:language_id))
        elsif member.admin?
          organization.languages.enabled
        else
          program_ids = abstract_program.is_a?(Program) ? [abstract_program.id] : member.program_ids
          Language.enabled.where(id: ProgramLanguage.enabled_for_all.where(program_id: program_ids).select("organization_languages.language_id"))
        end
      end
    supported_languages.to_a.flatten.uniq
  end

  # We dont need to have a language record in DB for english. Hence the proxy.
  def self.for_english
    Language.new({
      :title         => Language::TITLE_ENGLISH,
      :display_title => nil,
      :language_name => 'en'})
  end

  def self.get_user_ids_for_es_reindex_followup(languages)
    User.where(member_id: get_member_ids_for_es_reindex_followup(languages)).pluck(:id)
  end

  def self.get_member_ids_for_es_reindex_followup(languages)
    MemberLanguage.where(language_id: languages.map(&:id)).pluck(:member_id)
  end

  def to_display
    if self.default?
      self.title
    else
      "#{self.title} (#{self.display_title})"
    end
  end

  def default?
    self.language_name.to_s == I18n.default_locale.to_s
  end

  def get_title_in_organization(organization)
    self.for_organization(organization).try(:title) || self.title
  end

  def for_organization(organization)
    OrganizationLanguage.unscoped.find_by(organization_id: organization.id, language_name: self.language_name)
  end

  def sync_language_name_with_organization_language
    return unless self.saved_change_to_language_name?

    OrganizationLanguage.unscoped.where(language_id: self.id).update_all(language_name: self.language_name)
  end
end