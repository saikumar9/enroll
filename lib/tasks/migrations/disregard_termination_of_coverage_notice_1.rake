require File.join(Rails.root, "app", "data_migrations", "disregard_termination_of_coverage_notice_1")
#This rake task used to send employee secure message it expects HBX-ID as arguments.
# RAILS_ENV=production bundle exec rake secure_message:disregard_termination_of_coverage_notice
namespace :secure_message do
  desc "The employees of MA 10-1-2017 new groups received a notice in their accounts that their coverage was terminated because no payment was received from their employer."
  DisregardTerminationOfCoverageNotice1.define_task :disregard_termination_of_coverage_notice_1 => :environment
end