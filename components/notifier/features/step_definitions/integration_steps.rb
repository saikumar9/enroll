require 'pry'

def people
  return @a if defined?(@a)
  @a = {
    "Soren White" => {
      first_name: "Soren",
      last_name: "White",
      dob: "08/13/1979",
      dob_date: "13/08/1979".to_date,
      ssn: "670991234",
      home_phone: "2025551234",
      email: 'soren@dc.gov',
      password: 'aA1!aA1!aA1!',
      legal_name: "Acme Inc.",
      dba: "Acme Inc.",
      fein: "764141112",
      sic_code: "0111",
      mlegal_name: "Cogswell Cogs, Inc",
      mdba: "Cogswell Cogs, Inc",
      mfein: "211141467"
    },
    "Hbx Admin" => {
      email: 'admin@dc.gov',
      password: 'aA1!aA1!aA1!'
    },
    "John Doe" => {
      first_name: "John",
      last_name: "Doe#{rand(1000)}",
      dob: defined?(@u) ? @u.adult_dob : "08/13/1979",
      legal_name: "Turner Agency, Inc",
      dba: "Turner Agency, Inc",
      fein: defined?(@u) ? @u.fein : '123123123',
      ssn: defined?(@u) ? @u.ssn : "761234567",
      email: defined?(@u) ? @u.email : 'tronics@example.com',
      password: 'aA1!aA1!aA1!'
    }
  }
end

Given(/^Hbx Admin exists$/) do
  p_staff = Permission.create(name: 'hbx_staff', modify_family: true, modify_employer: true, revert_application: true,
                            list_enrollments: true, send_broker_agency_message: true, approve_broker: true, approve_ga: true,
                            modify_admin_tabs: true, view_admin_tabs: true, can_update_ssn: true, can_lock_unlock: true,
                            can_reset_password: true)
  person = people['Hbx Admin']
  hbx_profile = FactoryGirl.create :hbx_profile
  user = FactoryGirl.create :user, :with_person, :hbx_staff, email: person[:email], password: person[:password], password_confirmation: person[:password]
  FactoryGirl.create :hbx_staff_role, person: user.person, hbx_profile: hbx_profile, permission_id: p_staff.id
end

When(/^(.*) logs on to the (.*)?/) do |named_person, portal|
  person = people[named_person]

  @current_user = User.where(:email => person[:email]).first
  login_as(@current_user, :scope => :user)


  visit "/"


  # portal_class = "interaction-click-control-#{portal.downcase.gsub(/ /, '-')}"
  # portal_uri = find("a.#{portal_class}")["href"]

  # visit "/users/sign_in"
  # fill_in "user[login]", :with => person[:email]
  # find('#user_login').set(person[:email])
  # fill_in "user[password]", :with => person[:password]
  # #TODO this fixes the random login fails b/c of empty params on email
  # fill_in "user[login]", :with => person[:email] unless find(:xpath, '//*[@id="user_login"]').value == person[:email]
  # find('.interaction-click-control-sign-in').click
  # visit portal_uri
end

# Given(/^Hbx Admin clicks on the Notices tab$/) do
#   binding.pry
# end


