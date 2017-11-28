require File.join(Rails.root, "lib/mongoid_migration_task")

class DisregardTerminationOfCoverageNotice < MongoidMigrationTask
  def migrate
    #feins = ["261813097", "204560412", "821100214", "263082892"]
    feins = args[:fein].split(' ').uniq
    feins.each do |fein|
      begin
        org = Organization.where(:fein => fein).first
        employer_profile = org.employer_profile
        body = "Your employees should please disregard the notice that they received on 12/01/2017 stating that their employer was not offering health coverage through the Massachusetts Health Connector. This notice was sent in error. We apologize for any inconvenience this may have caused."+ 
          "<br><br>Your employees have received a correction message clarifying that their employer has completed its open enrollment period and has successfully met all eligibility requirements. It also confirms that the employees plan selection, if any, will go into effect on the coverage effective date shown in your account."+ 
          "<br><br>Thank you for enrolling into employer-sponsored coverage through the Health Connector." + 
          "<br><br> If you have any questions, please call 1-888-813-9220 (TTY: 711), press option 1."
        subject = "Disregard Termination of Coverage Notice"
        message = employer_profile.inbox.messages.build({ subject: subject, body: body, from: "MA Health Connector"})
        message.save!
      rescue => e
        puts "Unable to find Organization with FEIN #{fein}, due to -- #{e}" unless Rails.env.test?
      end
    end
  end
end