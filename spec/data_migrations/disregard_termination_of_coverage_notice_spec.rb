require "rails_helper"
require File.join(Rails.root, "app", "data_migrations", "disregard_termination_of_coverage_notice")

describe DisregardTerminationOfCoverageNotice, dbclean: :after_each do

  let(:given_task_name) { "disregard_termination_of_coverage_notice" }
  subject { DisregardTerminationOfCoverageNotice.new(given_task_name, double(:current_scope => nil)) }

  describe "given a task name" do
    it "has the given task name" do
      expect(subject.name).to eql given_task_name
    end
  end

  describe "disregard_termination_of_coverage_notice", dbclean: :after_each do
  	let!(:organization) {FactoryGirl.create(:organization, fein: "261813097")}
    let!(:employer_profile)  { FactoryGirl.create(:employer_profile, organization: organization) }

    before do
      allow(ENV).to receive(:[]).with("fein").and_return(organization.fein)
    end

    it "create_secure_inbox_message_for_employer" do
      subject.migrate
      employer_profile.reload
      expect(employer_profile.inbox.messages.count).to eq 1
    end
  end
end
