require File.join(Rails.root, "lib/mongoid_migration_task")

class DisregardTerminationOfCoverageNotice1 < MongoidMigrationTask
  def migrate

    #["100239", "100126", "100164", "100228", "100189", "100201", "100220", "100190", "100191", "100077", "100234","100204", "100202", "100238", "100226", "100211", "100206", "100218"]
    hbx_ids = args[:hbx_id].split(' ').uniq
    hbx_ids.each do |hbx_id|
      begin
        person = Person.where(:hbx_id => hbx_id).first
        body = "Please disregard the notice that you received on 12/01/2017 stating that your employer was not offering health coverage through the Massachusetts Health Connector. This notice was sent in error. We apologize for any inconvenience this may have caused." +
         "<br><br>Your employer has completed its open enrollment period and has successfully met all eligibility requirements." + 
         "<br><br>Your plan selection, if any, will go into effect on the coverage effective date shown in your account." +
         "<br><br>Thank you for enrolling into employer-sponsored coverage through the Health Connector."+ 
         "<br> <br>If you have any questions, please call 1-888-813-9220 (TTY: 711), press option 1."
        subject = "Disregard Termination of Coverage Notice"
        message = person.inbox.messages.build({ subject: subject, body: body, from: "MA Health Connector"})
        message.save!
      rescue => e
        puts "Unable to find employee with hbx_id #{hbx_id}, due to -- #{e}" unless Rails.env.test?
      end
    end
  end
end