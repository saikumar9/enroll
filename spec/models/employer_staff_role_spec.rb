require 'rails_helper'

describe EmployerStaffRole, dbclean: :after_each do

let(:person) { FactoryBot.create(:person) }
let(:employer_profile) { double(id: "valid_id") }

  describe ".new" do
    let(:valid_params) do
      {
        person: person,
        employer_profile_id: employer_profile.id
      }
    end

    context "with no arguments" do
      let(:params) {{}}

      it "should not save" do
        expect(EmployerStaffRole.new(**params).save).to be_falsey
      end
    end

     context "with valid params" do
      let(:params) { valid_params}

      it "should be valid" do
        expect(EmployerStaffRole.new(**params).valid?).to be_truthy
      end
     end

  end

  describe "notify_contact_changed" do

    context "notify update" do
      let(:employer_profile) { FactoryBot.create(:employer_profile_default) }
      let(:employer_staff_role) {FactoryBot.create(:employer_staff_role, person: person, employer_profile_id: employer_profile.id)}

      it "notify_contact_changed" do
        expect(employer_staff_role).to receive(:notify).exactly(1).times
        employer_staff_role.aasm_state='is_closed'
        employer_staff_role.save
      end
    end
  end
end
