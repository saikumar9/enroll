
require File.join(Rails.root, "lib/mongoid_migration_task")

class ChangeEmployerContributions < MongoidMigrationTask
  def migrate
    organizations = Organization.where(fein: ENV['fein'])
    state = ENV['aasm_state'].to_s
    kind = ENV['coverage_kind'].to_s
    relationship = ENV['relationship'].to_s
    premium = ENV['premium']
    offered = ENV['offered']
    if organizations.size !=1
      raise 'Issues with fein'
    end
    if kind == "health"
      rb = organizations.first.employer_profile.plan_years.where(aasm_state: state).first.benefit_groups.first.relationship_benefits.where(:relationship => relationship).first
    elsif kind == "dental"
      rb = organizations.first.employer_profile.plan_years.where(aasm_state: state).first.benefit_groups.first.dental_relationship_benefits.where(:relationship => relationship).first
    else
      raise "Please provide accurate coverage kind"
    end
    rb.update_attributes(:premium_pct => premium, offered: offered)
  end
end
