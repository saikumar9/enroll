class HbxProfile

  include Mongoid::Document
  include Mongoid::Timestamps

  embedded_in :organization

  field :cms_id, type: String
  field :us_state_abbreviation, type: String

  delegate :legal_name, :legal_name=, to: :organization, allow_nil: true
  delegate :dba, :dba=, to: :organization, allow_nil: true
  delegate :fein, :fein=, to: :organization, allow_nil: true
  delegate :entity_kind, :entity_kind=, to: :organization, allow_nil: true

  embeds_many :hbx_staff_roles
  
 end