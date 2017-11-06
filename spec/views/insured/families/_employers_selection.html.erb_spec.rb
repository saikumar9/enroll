require 'rails_helper'

RSpec.describe "insured/families/_employers_selection.html.erb" do
  let(:person) {FactoryBot.build(:person)}
  let(:employee_role) {FactoryBot.build(:employee_role)}
  let(:er1) { FactoryBot.build(:employer_profile) }
  let(:er2) { FactoryBot.build(:employer_profile) }
  let(:ce1) { FactoryBot.build(:census_employee, employer_profile: er1) }
  let(:ce2) { FactoryBot.build(:census_employee, employer_profile: er2) }

  before :each do
    allow(person).to receive(:active_census_employees).and_return([ce1, ce2])
    assign(:person, person)
    assign(:employee_role, employee_role)
    render "insured/families/employers_selection"
  end

  it "should have title" do
    expect(rendered).to have_content('Employers')
  end

  it "should get labels" do
    expect(rendered).to have_selector('div.n-radio-row')
  end

  it "should get legal_name of employer" do
    expect(rendered).to have_content(er1.legal_name)
    expect(rendered).to have_content(er2.legal_name)
  end

  it "should have form" do
    expect(rendered).to have_selector('form')
  end
end
