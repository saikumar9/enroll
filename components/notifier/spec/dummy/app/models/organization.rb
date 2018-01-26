class Organization
  include Mongoid::Document
  include Mongoid::Timestamps
 
  field :hbx_id, type: String
  field :issuer_assigned_id, type: String

  # Registered legal name
  field :legal_name, type: String

  # Doing Business As (alternate name)
  field :dba, type: String

  # Federal Employer ID Number
  field :fein, type: String

  # Web URL
  field :home_page, type: String

  field :is_active, type: Boolean

  field :is_fake_fein, type: Boolean

  # User or Person ID who created/updated
  field :updated_by, type: BSON::ObjectId

  embeds_one :hbx_profile, cascade_callbacks: true, validate: true

  validates_presence_of :legal_name, :fein

  validates :fein,
    length: { is: 9, message: "%{value} is not a valid FEIN" },
    numericality: true,
    uniqueness: true


  def self.generate_fein
    loop do
      random_fein = (["00"] + 7.times.map{rand(10)} ).join
      break random_fein unless Organization.where(:fein => random_fein).count > 0
    end
  end

  # Strip non-numeric characters
  def fein=(new_fein)
    write_attribute(:fein, new_fein.to_s.gsub(/\D/, ''))
  end
end
