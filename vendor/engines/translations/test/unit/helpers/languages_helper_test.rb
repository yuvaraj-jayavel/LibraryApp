require_relative '../../test_helper'
class LanguagesHelperTest < ActionView::TestCase
  include LanguagesHelper

  def test_get_available_languages
    program = programs(:albers)
    org = program.organization
    stub_current_program(program)
    ProgramLanguage.destroy_all
    Organization.any_instance.expects(:language_settings_enabled?).at_least(1).returns(true)
    LanguagesHelperTest.any_instance.stubs(:super_console?).returns(false)
    available_languages = get_available_languages
    languages = [{ title_for_display: "English", language_name: "en", tooltip: "English" }]
    assert_equal available_languages, languages

    organization_language = organization_languages(:hindi)
    organization_language.enabled = OrganizationLanguage::EnabledFor::ALL
    organization_language.program_ids_to_enable = [program.id]
    organization_language.save!

    available_languages = get_available_languages
    languages = [{ title_for_display: "English", language_name: "en", tooltip: "English" }, { title_for_display: "Hindi (Hindilu)", language_name: "de" }]
    assert_equal available_languages, languages

    org_lang = org.organization_languages.where(language_name: "de").first
    org_lang.update(title: "Org_Hindi", display_title: "Org_Hindilu")
    available_languages = get_available_languages
    languages = [{ title_for_display: "English", language_name: "en", tooltip: "English" }, { title_for_display: "Org_Hindi (Org_Hindilu)", language_name: "de" }]
    assert_equal available_languages, languages

    LanguagesHelperTest.any_instance.stubs(:super_console?).returns(true)
    OrganizationLanguage.update_all(enabled: OrganizationLanguage::EnabledFor::NONE)
    available_languages = get_available_languages
    languages = [{ title_for_display: "English", language_name: "en", tooltip: "English" }, { title_for_display: "Org_Hindi (Org_Hindilu)", language_name: "de" }, { title_for_display: "Telugu (Telugulu)", language_name: "es" }]
    assert_equal available_languages, languages
    available_languages = get_available_languages(from_non_org: true)
    languages = [{ title_for_display: "English", language_name: "en", tooltip: "English" }, { title_for_display: "Hindi (Hindilu)", language_name: "de" }, { title_for_display: "Telugu (Telugulu)", language_name: "es" }]
    assert_equal available_languages, languages

    org.stubs(:language_settings_enabled?).returns(false)
    assert_empty get_available_languages

    org.stubs(:language_settings_enabled?).returns(true)
    org.stubs(:active?).returns(false)
    assert_empty get_available_languages

    org.stubs(:active?).returns(true)
    LanguagesHelperTest.any_instance.stubs(:current_locale).returns(:de)
    available_languages = get_available_languages
    languages = [{ title_for_display: "Org_Hindi", language_name: "de", tooltip: "Org_Hindi (Org_Hindilu)" },{ title_for_display: "English", language_name: "en"}, { title_for_display: "Telugu (Telugulu)", language_name: "es" }]
    assert_equal languages, available_languages
  end

  def test_get_available_for_string
    assert END_USER_ONLY_LOCALES.all? { |locale| get_available_for_string(locale) == "Only End Users" }
    assert_equal "Everyone", get_available_for_string(:de)
  end

  def test_get_language_selection_redirect_path
    request = mock()
    request.stubs(:get?).returns(true)
    request.stubs(:fullpath).returns("full_path")
    stubs(:request).returns(request)

    assert_equal "full_path", get_language_selection_redirect_path
    request.stubs(:get?).returns(false)
    assert_equal "", get_language_selection_redirect_path
  end

  private

  def wob_member
    members(:f_mentor)
  end

  def program_context
    programs(:albers)
  end
end