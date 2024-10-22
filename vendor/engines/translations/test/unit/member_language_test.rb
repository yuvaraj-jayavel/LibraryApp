require_relative '../test_helper'

class MemberLanguageTest < ActiveSupport::TestCase

  def test_validates_member
    member_language = MemberLanguage.new
    assert_false member_language.valid?
    assert_equal ["can't be blank"], member_language.errors[:member]
    assert_equal ["can't be blank"], member_language.errors[:language]

    MemberLanguage.create!(member: members(:f_mentor), language: languages(:hindi))
  end

  def test_belongs_to
    member = members(:f_mentor)
    language = languages(:hindi)
    member_language = MemberLanguage.create!(member: member, language: language)
    assert_equal member_language.member, member
    assert_equal member_language.language, language
  end

  def test_es_reindex_followup
    member = members(:f_mentor)
    user_ids = member.user_ids

    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(User, user_ids).once
    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(Member, [member.id]).once
    member_language = MemberLanguage.create!(member: member, language: languages(:hindi))

    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(User, user_ids).once
    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(Member, [member.id]).once
    member_language.update_attribute(:language_id, languages(:telugu).id)

    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(User, user_ids).once
    DelayedEsDocument.expects(:delayed_bulk_update_es_documents).with(Member, [member.id]).once
    member_language.destroy
  end

  def test_es_reindex_followup_map
    assert_equal_hash( {
      create: ["Member", "User"],
      update: ["Member", "User"],
      delete: ["Member", "User"]
    }, MemberLanguage.es_reindex_followup_map)
  end

  def test_get_user_ids_for_es_reindex_followup
    expected_user_ids = users(:mentor_13, :mentor_14).map(&:id)
    assert_equal_unordered expected_user_ids, MemberLanguage.get_user_ids_for_es_reindex_followup(member_languages(:hindi_member, :telugu_member))
  end

  def test_fed_ramp_compliance
    refute_fed_ramp_compliant(MemberLanguage.first)
  end
end