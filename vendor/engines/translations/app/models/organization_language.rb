class OrganizationLanguage < ApplicationRecord
  include FedRampExcludable
  include HasEsReindexFollowups

  MASS_UPDATE_ATTRIBUTES = {
    update_status: [:language_id, :title, :display_title, :enabled]
  }

  module EnabledFor
    NONE  = 0
    ADMIN = 1
    ALL   = 2

    def self.all
      (NONE..ALL)
    end
  end

  belongs_to :organization
  belongs_to :language
  has_many :program_languages, dependent: :delete_all

  validates :organization,   :presence => true
  validates :language,  :presence => true
  validates :enabled, inclusion: { in: EnabledFor.all }
  validates :organization, uniqueness: { scope: :language }
  sanitize_fields text_fields: [:title, :display_title]

  scope :enabled, -> { where(enabled: EnabledFor::ALL) }
  default_scope -> { where.not(enabled: EnabledFor::NONE) }

  attr_accessor :program_ids_to_enable

  register_es_reindex_followup ["User", "Member"], on: :save, if: :saved_change_to_title?

  def self.for_english
    english_language = Language.for_english
    OrganizationLanguage.new(
      enabled: EnabledFor::ALL,
      title: english_language.title,
      display_title: english_language.display_title,
      language_name: english_language.language_name
    )
  end

  def self.get_member_ids_for_es_reindex_followup(organization_languages)
    language_ids, organization_ids = organization_languages.pluck(:language_id, :organization_id).transpose

    MemberLanguage.
      joins(:member).
      where(language_id: language_ids).
      where(members: { organization_id: organization_ids } ).
      pluck(:member_id)
  end

  def self.get_user_ids_for_es_reindex_followup(organization_languages)
    User.where(member_id: get_member_ids_for_es_reindex_followup(organization_languages)).pluck(:id)
  end

  def to_display(language_title: nil)
    title(language_title: language_title) + (display_title ? " (#{self.display_title})" : "")
  end

  def enabled_for_admin?
    self.enabled == EnabledFor::ADMIN
  end

  def enabled_for_all?
    self.enabled == EnabledFor::ALL
  end

  def disabled?
    self.enabled == EnabledFor::NONE
  end

  def enabled_program_ids
    self.program_languages.pluck(:program_id)
  end

  def title(language_title: nil)
    self[:title].presence || language_title || self.language.title
  end

  def handle_enabled_program_languages
    return if self.program_ids_to_enable.nil?
    self.program_ids_to_enable = [] if self.disabled?
    enabled_program_ids_in_db = self.enabled_program_ids
    enable_for_program_ids(self.program_ids_to_enable - enabled_program_ids_in_db)
    disable_for_program_ids(enabled_program_ids_in_db - self.program_ids_to_enable)
  end

  private

  def enable_for_program_ids(program_ids_to_enable)
    program_ids_to_enable.each { |program_id| self.program_languages.create!(program_id: program_id) }
  end

  def disable_for_program_ids(program_ids_to_disable)
    self.program_languages.where(program_id: program_ids_to_disable).destroy_all
  end
end