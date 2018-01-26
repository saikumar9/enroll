class Person
  include Mongoid::Document
  include Mongoid::Timestamps

  GENDER_KINDS = %W(male female)

  field :hbx_id, type: String
  field :name_pfx, type: String
  field :first_name, type: String
  field :middle_name, type: String
  field :last_name, type: String
  field :name_sfx, type: String
  field :full_name, type: String
  field :alternate_name, type: String

  field :encrypted_ssn, type: String
  field :gender, type: String
  field :dob, type: Date

  # Sub-model in-common attributes
  field :date_of_death, type: Date
  field :dob_check, type: Boolean

  field :is_incarcerated, type: Boolean

  field :is_disabled, type: Boolean
  field :ethnicity, type: Array
  field :race, type: String
  field :tribal_id, type: String

  field :is_tobacco_user, type: String, default: "unknown"
  field :language_code, type: String

  field :no_dc_address, type: Boolean, default: false
  field :no_dc_address_reason, type: String, default: ""

  field :is_active, type: Boolean, default: true
  field :updated_by, type: String
  field :no_ssn, type: String #ConsumerRole TODO TODOJF


  # Login account
  belongs_to :user

  embeds_one :hbx_staff_role, cascade_callbacks: true, validate: true
  embeds_one :inbox, as: :recipient
  
  validates_presence_of :first_name, :last_name

  validates :encrypted_ssn, uniqueness: true, allow_blank: true

  validates :gender,
    allow_blank: true,
    inclusion: { in: Person::GENDER_KINDS, message: "%{value} is not a valid gender" }


  def ssn=(new_ssn)
    if !new_ssn.blank?
      write_attribute(:encrypted_ssn, self.class.encrypt_ssn(new_ssn))
    else
      unset_sparse("encrypted_ssn")
    end
  end

  def ssn
    ssn_val = read_attribute(:encrypted_ssn)
    if !ssn_val.blank?
      self.class.decrypt_ssn(ssn_val)
    else
      nil
    end
  end
end