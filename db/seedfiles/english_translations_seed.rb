puts "*"*80
puts "::: Generating English Translations :::"

translations = {
  "en.layouts.application_brand.call_customer_service" => "Call Customer Service",
  "en.layouts.application_brand.help" => "Help",
  "en.layouts.application_brand.logout" => "Logout",
  "en.layouts.application_brand.my_id" => "My ID",
  "en.shared.my_portal_links.my_insured_portal" => "My Insured Portal",
  "en.uis.bootstrap3_examples.index.alerts_link" => "Jump to the alerts section of this page",
  "en.uis.bootstrap3_examples.index.badges_link" => "Jump to the badges section of this page",
  "en.uis.bootstrap3_examples.index.body_copy" => "Body Copy",
  "en.uis.bootstrap3_examples.index.body_copy_text" => "Nullam quis risus eget urna mollis ornare vel eu leo. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam id dolor id nibh ultricies vehicula.  Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec ullamcorper nulla non metus auctor fringilla. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit. Donec ullamcorper nulla non metus auctor fringilla.  Maecenas sed diam eget risus varius blandit sit amet non magna. Donec id elit non mi porta gravida at eget metus. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit.",
  "en.uis.bootstrap3_examples.index.buttons_link" => "Jump to the buttons section of this page",
  "en.uis.bootstrap3_examples.index.carousels_link" => "Jump to the carousels section of this page",
  "en.uis.bootstrap3_examples.index.heading_1" => "Heading 1",
  "en.uis.bootstrap3_examples.index.heading_2" => "Heading 2",
  "en.uis.bootstrap3_examples.index.heading_3" => "Heading 3",
  "en.uis.bootstrap3_examples.index.heading_4" => "Heading 4",
  "en.uis.bootstrap3_examples.index.heading_5" => "Heading 5",
  "en.uis.bootstrap3_examples.index.heading_6" => "Heading 6",
  "en.uis.bootstrap3_examples.index.headings" => "Headings",
  "en.uis.bootstrap3_examples.index.inputs_link" => "Jump to the inputs section of this page",
  "en.uis.bootstrap3_examples.index.navigation_link" => "Jump to the navigation section of this page",
  "en.uis.bootstrap3_examples.index.pagination_link" => "Jump to the pagination section of this page",
  "en.uis.bootstrap3_examples.index.panels_link" => "Jump to the panels section of this page",
  "en.uis.bootstrap3_examples.index.progressbars_link" => "Jump to the progress bars section of this page",
  "en.uis.bootstrap3_examples.index.tables_link" => "Jump to the tables section of this page",
  "en.uis.bootstrap3_examples.index.tooltips_link" => "Jump to the tooltips section of this page",
  "en.uis.bootstrap3_examples.index.typography" => "Typography",
  "en.uis.bootstrap3_examples.index.typography_link" => "Jump to the typography section of this page",
  "en.uis.bootstrap3_examples.index.wells_link" => "Jump to the wells section of this page",
  "en.wecome.index.sign_out" => "Sign Out",
  "en.welcome.index.assisted_consumer_family_portal" => "Assisted Consumer/Family Portal",
  "en.welcome.index.broker_agency_portal" => "Broker Agency Portal",
  "en.welcome.index.broker_registration" => "Broker Registration",
  "en.layouts.application_brand.byline" => "The Right Place for the Right Plan",
  "en.welcome.index.consumer_family_portal" => "Consumer/Family Portal",
  "en.welcome.index.employee_portal" => "Employee Portal",
  "en.welcome.index.employer_portal" => "Employer Portal",
  "en.welcome.index.general_agency_portal" => "General Agency Portal",
  "en.welcome.index.general_agency_registration" => "General Agency Registration",
  "en.welcome.index.hbx_portal" => "HBX Portal",
  "en.welcome.index.logout" => "Logout",
  "en.welcome.index.returning_user" => "Returning User",
  "en.welcome.index.signed_in_as" => "Signed in as %{current_user}",
  "en.welcome.index.welcome_email" => "Welcome %{current_user}",
  "en.welcome.index.welcome_to_site_name" => "Welcome to %{short_name}",
  
    # Employers/broker_agency/_active_broker.html.erb 
  "en.employers.broker_agency.active_broker.brokers" => "Brokers",
  "en.employers.broker_agency.active_broker.active_broker" => "Active Broker",
  "en.employers.broker_agency.active_broker.submit" => "Submit",
  "en.employers.broker_agency.active_broker.broker_name" => "Broker Name:",
  "en.employers.broker_agency.active_broker.phone" => "Phone:",
  "en.employers.broker_agency.active_broker.broker_agency" => "Broker Agency:",
  "en.employers.broker_agency.active_broker.email" => "Email:",
  "en.employers.broker_agency.active_broker.address" => "Address:",
  "en.employers.broker_agency.active_broker.accepting_new_clients" => "Accepting New Clients:",
  "en.employers.broker_agency.active_broker.language" => "Language:",
  "en.employers.broker_agency.active_broker.weekend_evening" => "Weekend/Evening Hours:",
  "en.employers.broker_agency.active_broker.assignment_date" => "Assignment Date:",
  "en.employers.broker_agency.active_broker.broker_termination_confirmation" => "Broker Termination Confirmation",
  "en.employers.broker_agency.active_broker.select_terminate" => "Select 'Terminate' to unhire the selected Broker. They will be terminated effective immediately.",
  "en.employers.broker_agency.active_broker.close" => "Close",
    
    # Employers/broker_agency/_active_broker_modal.html.erb
  "en.employers.broker_agency.active_broker_modal.no_address" => "No Address",
  "en.employers.broker_agency.active_broker_modal.no_phone_number" => "No Phone Number",
  "en.employers.broker_agency.active_broker_modal.new_clients" => "New Clients:",
  "en.employers.broker_agency.active_broker_modal.weekend_evening" => "Weekend/Evening Hours:",
  "en.employers.broker_agency.active_broker_modal.language" => "Language:",
  "en.employers.broker_agency.active_broker_modal.close" => "Close",
  
    # Employers/broker_agency/_broker.html.erb
  "en.employers.broker_agency.broker.broker_selection_confirmation" => "Broker Selection Confirmation",
  "en.employers.broker_agency.broker.select_confirm" => "Select 'Confirm' to hire the selected Broker. Warning: if you already have an existing Broker, they will be terminated effective immediately.",
  "en.employers.broker_agency.broker.close" => "Close",

    # Employers/broker_agency/_broker_agencies_listing.html.erb
  "en.employers.broker_agency.broker_agencies_listing.agency_name" => "Agency Name",
  "en.employers.broker_agency.broker_agencies_listing.evening_weekend" => "Evening/Weekend Hours",
  "en.employers.broker_agency.broker_agencies_listing.languages_spoken" => "Language(s) spoken",
  "en.employers.broker_agency.broker_agencies_listing.broker_name" => "Broker Name",
  "en.employers.broker_agency.broker_agencies_listing.npn" => "NPN",

    # Employers/broker_agency/_fields.html.erb
  "en.employers.broker_agency.fields.agency" => "Agency",
  "en.employers.broker_agency.fields.broker" => "Broker",
  "en.employers.broker_agency.fields.broker_npn" => "Broker NPN",
  "en.employers.broker_agency.fields.contact_phone" => "Contact Phone",
  "en.employers.broker_agency.fields.email" => "Email",

    # Employers/broker_agency/_index.html.erb
  "en.employers.broker_agency.index.broker_agencies" => "Broker Agencies",
  "en.employers.broker_agency.index.advanced_options" => "Advanced Options",
  "en.employers.broker_agency.index.evening_weekend" => "Evening/Weekend Availability",
  "en.employers.broker_agency.index.search_for_broker" => "Search for a Broker near you. When you find the Broker you want to use, choose 'Select Broker' to hire the Broker.",

    # Employers/broker_agency/_show.html.erb
  "en.employers.broker_agency.show.cancel" => "Cancel",
  "en.employers.broker_agency.show.broker_agency" => "Broker Agency :",
  "en.employers.broker_agency.show.legal_name" => "Legal Name",
  "en.employers.broker_agency.show.dba" => "dba",
  "en.employers.broker_agency.show.fein" => "Fein",
  "en.employers.broker_agency.show.entity_kind" => "Entity Kind",
  "en.employers.broker_agency.show.market_kind" => "Market Kind",
  "en.employers.broker_agency.show.office_locations" => "Office Locations",

    # Employers/census_employees/_address_fields.html.erb
  "en.employers.census_employees.address_fields.address_capital" => "ADDRESS",
  "en.employers.census_employees.address_fields.address" => "Address",

    # Employers/census_employees/_cobra_fields.html.erb
  "en.employers.census_employees.cobra_fields.check_the_box" => "Check the box if this person is already in enrolled into COBRA/Continuation outside of",
  "en.employers.census_employees.cobra_fields.cobra_begin_date" => "COBRA Begin Date",

    # Employers/census_employees/_details.html.erb
  "en.employers.census_employees.cobra_fields.check_the_box" => "Check the box if this person is already in enrolled into COBRA/Continuation outside of",














  "en.employer.show.employer_details" => "Employer Details",
  "en.employer.show.employer_roster" => "Employer Roster",
  "en.employer.show.employee_name" => "Employee Name",
  "en.employer.show.dob" => "DOB",
  "en.employer.index.employers" => "Employers",
  "en.employer.index.name" => "Name",
  "en.employer.index.fein" => "FEIN",
  "en.employer.index.type" => "Type",
  "en.employer.welcome_msg.first" => "Employer registration begins here.",
  "en.employer.welcome_msg.second" => "Let’s get you signed up for health care. Lorem ipsum dolot sit amet. Ut enim ad minim vineam, quis nostrud exarciation ullamco laboris nisi ut.",
  "en.employer_profiles.broker_info_fields.all_fields" => "All fields Required",
  "en.employer_profiles.download_new_template.unrecognized" => "Unrecognized Employee Census spreadsheet format.",
  "en.employer_profiles.download_new_template.need" => "Need the new template?",
  "en.employer_profiles.download_new_template.download" => "Download it now.",
  "en.employer_profiles.download_new_template.issues" => "If you are still having Issues Contact",
  "en.employer_profiles.employer_broker_widget.your_broker" => "Your Broker",
  "en.employer_profiles.employer_broker_widget.select_broker" => "Select a Broker",
  "en.employer_profiles.employer_broker_widget.no_broker" => "No Broker",
  "en.employer_profiles.employer_form.business_info" => "Business Info",
  "en.employer_profiles.employer_form.point_of_contact" => "Point of Contact - Employer Staff",
  "en.employer_profiles.employer_info_form.employer_name" => "Employer Name",
  "en.employer_profiles.employer_info_form.entity_kind" => "Entity Kind",
  "en.employer_profiles.employer_info_form.dba" => "DBA",
  "en.employer_profiles.employer_invoices_table.coverage_period" => "Coverage Period",
  "en.employer_profiles.employer_invoices_table.you_dont" => "You don't have any invoices. When you do, they will be displayed here.",
  "en.employer_profiles.employer_menu.profile" => "Profile",
  "en.employer_profiles.employer_menu.employees" => "Employees",
  "en.employer_profiles.employer_menu.benefits" => "Benefits",
  "en.employer_profiles.employer_menu.documents" => "Documents",
  "en.employer_profiles.employer_menu.inbox" => "Inbox",
  "en.employer_profiles.enrollment_report_widget.enrollment_report" => "Enrollment Report",
  "en.employer_profiles.enrollment_report_widget.total_premium" => "Total Premium:",
  "en.employer_profiles.enrollment_report_widget.employee_contributions" => "Employee Contributions:",
  "en.employer_profiles.enrollment_report_widget.employer_contributions" => "Employer Contributions:",
  "en.employer_profiles.form.thank_you" => "Thank you for logging into your",
  "en.employer_profiles.form.employer_account" => "Employer account.",
  "en.employer_profiles.form.befor_we_get" => "Before we get started, we need to confirm the primary point of contact for your business. Please confirm that the name and email address listed below are correct, update the information or provide the name and email address for your primary point of contact. When you're finished, select 'Confirm'.",
  "en.employer_profiles.form.if_the_organization" => "If the organization already has a staff role you will will be placed in applicant status for an additional staff role.",
  "en.employer_profiles.form.employer_information" => "Employer Information",
  "en.employer_profiles.form.confirm" => "Confirm",
  "en.employer_profiles.index_table.hbx_acct" => "HBX Acct",
  "en.employer_profiles.index_table.legal_name" => "Legal Name",
  "en.employer_profiles.index_table.ee_ct" => "EE Ct",
  "en.employer_profiles.index_table.enroll_status" => "Enroll Status",
  "en.employer_profiles.index_table.effective_date" => "Effective Date",
  "en.employer_profiles.index_table.assigned_broker" => "Assigned Broker",
  "en.employer_profiles.index_table.broker_agency" => "Broker Agency",
  "en.employer_profiles.index_table.general_agency" => "General Agency",
  "en.employer_profiles.menu.home" => "Home"







}

translations.keys.each do |k|
  Translation.where(key: k).first_or_create.update_attributes!(value: "\"#{translations[k]}\"")
end

puts "::: English Translations Complete :::"
puts "*"*80
