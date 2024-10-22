require_relative '../test_helper'

class OrganizationLanguageTest < ActiveSupport::TestCase
  def test_validates_organization
    organization_language = OrganizationLanguage.new(enabled: -1)
    assert_false organization_language.valid?
    assert_equal(["can't be blank"], organization_language.errors[:organization])
    assert_equal(["can't be blank"], organization_language.errors[:language])
    assert_equal(["is not included in the list"], organization_language.errors[:enabled])
    organization_language = OrganizationLanguage.create(:organization => programs(:org_primary), :language => languages(:hindi))
    assert_false organization_language.valid?
    assert_equal(["has already been taken"], organization_language.errors[:organization])
  end

  def test_belongs_to
    organization = programs(:org_anna_univ)
    language = languages(:hindi)
    organization_language = OrganizationLanguage.create!(:organization => programs(:org_anna_univ), :language => language)
    assert_equal organization_language.organization, organization
    assert_equal organization_language.language, language
  end

  def test_has_many
    assert_equal programs(:org_primary).programs_count,
      organization_languages(:hindi).program_languages.size
  end

  def test_scopes
    organization = programs(:org_primary)
    hindi = organization_languages(:hindi)
    telugu = organization_languages(:telugu)
    assert_equal_unordered [hindi, telugu].collect(&:id), organization.organization_languages.pluck(:id)
    assert_equal_unordered [hindi, telugu].collect(&:id), organization.organization_languages.enabled.pluck(:id)

    hindi.update!(enabled: OrganizationLanguage::EnabledFor::ADMIN)
    assert_equal_unordered [hindi, telugu].collect(&:id), organization.organization_languages.all.pluck(:id)
    assert_equal_unordered [telugu].collect(&:id), organization.organization_languages.enabled.pluck(:id)

    hindi.update!(enabled: OrganizationLanguage::EnabledFor::NONE)
    assert_equal_unordered [telugu].collect(&:id), organization.organization_languages.all.pluck(:id)
    assert_equal_unordered [telugu].collect(&:id), organization.organization_languages.enabled.pluck(:id)
  end

  def test_enabled_for_admin
    organization_language = organization_languages(:hindi)
    assert_false organization_language.enabled_for_admin?

    organization_language.update(enabled: OrganizationLanguage::EnabledFor::ADMIN)
    assert organization_language.enabled_for_admin?
  end

  def test_enabled_for_all
    organization_language = organization_languages(:hindi)
    assert organization_language.enabled_for_all?

    organization_language.update(enabled: OrganizationLanguage::EnabledFor::ADMIN)
    assert_false organization_language.enabled_for_all?
  end

  def test_disabled
    organization_language = organization_languages(:hindi)
    assert_false organization_language.disabled?

    organization_language.update(enabled: OrganizationLanguage::EnabledFor::NONE)
    assert organization_language.disabled?
  end

  def test_enabled_program_ids
    organization = programs(:org_primary)
    organization_language = organization_languages(:hindi)
    assert_equal_unordered organization.program_ids, organization_language.enabled_program_ids

    new_enabled_program_ids = organization.program_ids[0..-2]
    organization_language.program_ids_to_enable = new_enabled_program_ids
    organization_language.handle_enabled_program_languages
    assert_equal_unordered new_enabled_program_ids, organization_language.enabled_program_ids
  end

  def test_handle_enabled_program_languages
    organization = programs(:org_primary)
    organization_language = organization_languages(:hindi)
    enabled_program_ids = organization_language.enabled_program_ids

    assert_difference "ProgramLanguage.count", -1 do
      organization_language.program_ids_to_enable = enabled_program_ids[0..-2]
      organization_language.handle_enabled_program_languages
    end

    assert_difference "ProgramLanguage.count" do
      organization_language.program_ids_to_enable = enabled_program_ids
      organization_language.handle_enabled_program_languages
    end

    organization_language.stubs(:disabled?).returns(true)
    assert_difference "ProgramLanguage.count", -organization_language.program_languages.size do
      organization_language.program_ids_to_enable = enabled_program_ids
      organization_language.handle_enabled_program_languages
    end

    organization_language.stubs(:disabled?).returns(false)
    assert_no_difference "ProgramLanguage.count" do
      organization_language.handle_enabled_program_languages
    end
  end

  def test_to_display
    hindi = organization_languages(:hindi)
    assert_equal "Hindi (Hindilu)", hindi.to_display
    assert_equal "Hindi (Hindilu)", hindi.to_display(language_title: "Tamil")
    hindi.title = nil
    assert_equal "Tamil (Hindilu)", hindi.to_display(language_title: "Tamil")
    assert_equal "English", OrganizationLanguage.for_english.to_display
  end

  def test_for_english
    english_language = Language.for_english
    english_org_language = OrganizationLanguage.for_english
    assert english_org_language.enabled
    assert_equal english_language.title, english_org_language.title
    assert_nil english_language.display_title
    assert_nil english_org_language.display_title
    assert_equal english_language.language_name, english_org_language.language_name
  end

  def test_es_reindex_followup
    organization_language = organization_languages(:hindi)

    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(User, [users(:mentor_13).id]).once
    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(Member, [members(:mentor_13).id]).once
    organization_language.update_attribute(:title, "Oriya")

    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).never
    organization_language.update_attribute(:display_title, "Oriya (Orissa)")
  end

  def test_es_reindex_followup_map
    assert_equal_hash( {
      create: ["User", "Member"],
      update: ["User", "Member"],
      delete: []
    }, OrganizationLanguage.es_reindex_followup_map)
  end

  def test_get_member_ids_for_es_reindex_followup
    expected_member_ids = members(:mentor_13, :mentor_14).map(&:id)
    assert_equal_unordered expected_member_ids, OrganizationLanguage.get_member_ids_for_es_reindex_followup(organization_languages(:telugu, :hindi))
  end

  def test_get_user_ids_for_es_reindex_followup
    expected_user_ids = users(:mentor_13, :mentor_14).map(&:id)
    assert_equal_unordered expected_user_ids, OrganizationLanguage.get_user_ids_for_es_reindex_followup(organization_languages(:telugu, :hindi))
  end

  def test_fed_ramp_compliance
    refute_fed_ramp_compliant(OrganizationLanguage.first)
  end

  def test_xss_sanity
    xss_sanitation_check(OrganizationLanguage.last, text_fields: [:title, :display_title])
  end

end
