require "rails_helper"
require File.join(Rails.root, "app", "data_migrations", "disregard_termination_of_coverage_notice_1")

describe DisregardTerminationOfCoverageNotice1, dbclean: :after_each do

  let(:given_task_name) { "disregard_termination_of_coverage_notice_1" }
  subject { DisregardTerminationOfCoverageNotice1.new(given_task_name, double(:current_scope => nil)) }

  describe "given a task name" do
    it "has the given task name" do
      expect(subject.name).to eql given_task_name
    end
  end

  describe "disregard_termination_of_coverage_notice_1", dbclean: :after_each do
    let!(:person) { FactoryGirl.create(:person, hbx_id: "100239") }

    before do
      allow(ENV).to receive(:[]).with('hbx_id').and_return person.hbx_id
    end


    it "create_secure_inbox_message_for_employee" do
    	subject.migrate
    	expect(person.inbox.messages.count).to eq 1
    end
  end
end
