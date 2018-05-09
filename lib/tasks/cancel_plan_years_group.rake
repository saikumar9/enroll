require 'csv'
require 'date'

namespace :migrations do

  desc "Cancel Plan Years based on CSV file"

  task :cancel_plan_years_group => :environment do

    CSV.foreach("#{Rails.root}/CancelPlanYears.csv", headers: true) do |row|
      date =(Date.strptime(row['start_on'],'%m/%d/%Y').to_date)
      if !EmployerProfile.find_by_fein(row['FEIN']).present?
        puts "employer not found #{row['FEIN']}" 
      else  
        plan_year=EmployerProfile.find_by_fein(row['FEIN']).plan_years.where(start_on: date).first
        if plan_year.aasm_state == (row['aasm_state'])
            if ["application_ineligible","renewing_application_ineligible"].include? plan_year.aasm_state
          enrollments = all_enrollments(plan_year.benefit_groups)
          enrollments.each { |enr| enr.cancel_coverage! if enr.may_cancel_coverage? }
          puts "canceled enrollments for ineligible plan year"
          plan_year.revert_application! if plan_year.may_revert_application?
          plan_year.cancel! if plan_year.may_cancel?
          puts "canceled ineligible plan year for #{row['FEIN']}"
          else
          system("rake migrations:cancel_plan_year feins='#{row['FEIN']}' plan_year_state='#{row['aasm_state']}'")
          puts "Plan Year Cancelled for #{row['FEIN']}" unless Rails.env.test?
          end
        end  
      end
    end
  end 
    def all_enrollments(benefit_groups=[])
      id_list = benefit_groups.collect(&:_id).uniq
      families = Family.where(:"households.hbx_enrollments.benefit_group_id".in => id_list)
      families.inject([]) do |enrollments, family|
      enrollments += family.active_household.hbx_enrollments.where(:benefit_group_id.in => id_list).to_a
      end
    end
end