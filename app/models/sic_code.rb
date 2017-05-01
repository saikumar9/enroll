class SicCode
	include Mongoid::Document

	field :sic, type: String
	field :hios_id, type: String
	field :cost_ratio, type: Float
	field :applicable_year, type: Integer
	

	validates :sic, :hios_id, presence: true
	validates :sic, :hios_id, uniqueness: true
	validates :cost_ratio, allow_nil: true

end
