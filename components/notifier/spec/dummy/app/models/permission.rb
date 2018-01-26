class Permission
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String

  field :modify_family, type: Boolean, default: false
  field :modify_employer, type: Boolean, default: false
  field :revert_application, type: Boolean, default: false
  field :list_enrollments, type: Boolean, default: false
  field :send_broker_agency_message, type: Boolean, default: false
  field :approve_broker, type: Boolean, default: false
  field :approve_ga, type: Boolean, default: false
  field :modify_admin_tabs, type: Boolean, default: false
  field :view_admin_tabs, type: Boolean, default: false
  field :can_update_ssn, type: Boolean, default: false
  field :can_complete_resident_application, type: Boolean, default: false
  field :can_lock_unlock, type: Boolean, default: false
  field :can_reset_password, type: Boolean, default: false

end
