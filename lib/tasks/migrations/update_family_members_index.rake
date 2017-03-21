require File.join(Rails.root, "app", "data_migrations", "update_family_members_index")
# This rake task is to delete employee_role_id of enrollments with individual kind
# RAILS_ENV=production bundle exec rake migrations:update_family_members_index hbx_id_1="19771145" hbx_id_2="19771142" person_id_1="5689b5df50526c1ef700014d" person_id_2="5689b6cc50526c5978000046" 
#local: bundle exec rake migrations:update_family_members hbx_id_1="6fee833c249c49c1a797a7555bd25d6a" hbx_id_2="3739efb8ecea4e0f89a498725fae4e9b" person_id_1="58d168057a3672386800006b" person_id_2="58d165517a36723868000057" 

namespace :migrations do
  desc "delete employee_role_id of enrollments with individual kind"
  UpdateFamilyMembers.define_task :update_family_members_index => :environment
end