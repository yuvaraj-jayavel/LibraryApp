class MemberLanguage < ApplicationRecord
  include FedRampExcludable
  include HasEsReindexFollowups

  belongs_to :member
  belongs_to :language

  validates :member, :language, presence: true

  register_es_reindex_followup "Member", column: :member_id
  register_es_reindex_followup "User"

  def self.get_user_ids_for_es_reindex_followup(member_languages)
    User.where(member_id: member_languages.map(&:member_id)).pluck(:id)
  end

  def organization_language
    OrganizationLanguage.unscoped.find_by(organization_id: member.organization_id, language_id: language_id)
  end
end