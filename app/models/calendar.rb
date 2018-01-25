class Calendar
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :name, type: String
  field :organization, type: String
  field :is_published, type: Boolean, default: false
  field :author_id, type: Integer, default: 0
  field :color, type: String, default: "#4da6ff"
  
  validates_presence_of :name
  
  
  embeds_many :scheduled_events
end