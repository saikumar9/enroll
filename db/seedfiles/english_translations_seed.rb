Dir.glob('db/seedfiles/translations/*').each do |file|
  require_relative 'translations/' + File.basename(file,File.extname(file))
end

puts "*"*80
puts "::: Generating English Translations :::"

<<<<<<< HEAD
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
  "en.uis.bootstrap3_examples.index.alerts" => "Alerts",
  "en.uis.bootstrap3_examples.index.div_alert_success" => "Create a div with class 'alert alert-success' ",
  "en.uis.bootstrap3_examples.index.your_computer" => "Your computer restarted ",
  "en.uis.bootstrap3_examples.index.because_problem" => "because of a problem.",
  "en.uis.bootstrap3_examples.index.sorry_for_inconvenience" => "Sorry for any inconvenience and appreciate your patient.",
  "en.uis.bootstrap3_examples.index.disc_space" => "Disc Space was extended twice. It’s ok? ",
  "en.uis.bootstrap3_examples.index.an_error_message" => "An error message is information displayed when an  ",
  "en.uis.bootstrap3_examples.index.unexpected_condition" => "unexpected condition occurs ",
  "en.uis.bootstrap3_examples.index.usually_on_a_computer" => ", usually on a computer or other device. On modern operating systems with graphical user interfaces, error messages are often displayed using dialog boxes. ",
  "en.uis.bootstrap3_examples.index.hurray" => "Hurray! ",
  "en.uis.bootstrap3_examples.index.share_on_twitter" => "Share on twitter ",
  "en.uis.bootstrap3_examples.index.div_alert_info" => "Create a div with class 'alert alert-info' ",
  "en.uis.bootstrap3_examples.index.information_label" => "Information Label ",
  "en.uis.bootstrap3_examples.index.turn_it_off" => "Turn it off now ",
  "en.uis.bootstrap3_examples.index.its_ok" => "It’s ok ",
  "en.uis.bootstrap3_examples.index.div_alert_warning" => "Create a div with class 'alert alert-warning' ",
  "en.uis.bootstrap3_examples.index.error_the_change" => "Error: The change you wanted was rejected. ",
  "en.uis.bootstrap3_examples.index.div_alert_danger" => "Create a div with class 'alert alert-danger' ",
  "en.uis.bootstrap3_examples.index.dismissible" => "Dismissible ",
  "en.uis.bootstrap3_examples.index.warning" => "Warning! ",
  "en.uis.bootstrap3_examples.index.better_check_yourself" => "Better check yourself, you're not looking too good. ",
  "en.uis.bootstrap3_examples.index.tabs" => " Tabs ",
  "en.uis.bootstrap3_examples.index.popular" => " Popular ",
  "en.uis.bootstrap3_examples.index.newest" => " Newest  ",
  "en.uis.bootstrap3_examples.index.bestselling" => " Bestselling  ",
  "en.uis.bootstrap3_examples.index.disabled_tab" => "Disabled Tab  ",
  "en.uis.bootstrap3_examples.index.section_one" => "I'm in Section 1.  ",
  "en.uis.bootstrap3_examples.index.section_two" => "Howdy, I'm in Section 2.  ",
  "en.uis.bootstrap3_examples.index.section_three" => "Howdy, I'm in Section 3.  ",
  "en.uis.bootstrap3_examples.index.section_disbaled" => "This section is disabled.  ",
  "en.uis.bootstrap3_examples.index.tab_dropdown" => "Tab with Dropdown  ",
  "en.uis.bootstrap3_examples.index.home" => "Home  ",
  "en.uis.bootstrap3_examples.index.sub_options" => "Sub Options  ",
  "en.uis.bootstrap3_examples.index.sub_option_divider" => "Sub Option below a divider  ",
  "en.uis.bootstrap3_examples.index.profile" => "Profile  ",
  "en.uis.bootstrap3_examples.index.messages" => "Messages  ",
  "en.uis.bootstrap3_examples.index.file_input" => "File Input",
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
  "en.welcome.index.welcome_to_site_name" => "Welcome to %{short_name}"
=======
MAIN_TRANSLATIONS = {
  "en.shared.my_portal_links.my_insured_portal" => "My Insured Portal"
>>>>>>> 10a8851f5eb8156ab699e9c593dcf0183b14029e
}
translations = [
  BOOTSTRAP_EXAMPLE_TRANSLATIONS,
  LAYOUT_TRANSLATIONS,
  MAIN_TRANSLATIONS,
  USERS_ORPHANS_TRANSLATIONS,
  WELCOME_INDEX_TRANSLATIONS
].reduce({}, :merge)

translations.keys.each do |k|
  Translation.where(key: k).first_or_create.update_attributes!(value: "\"#{translations[k]}\"")
end

puts "::: English Translations Complete :::"
puts "*"*80
