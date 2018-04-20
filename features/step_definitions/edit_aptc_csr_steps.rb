
Then (/^Hbx Admin sees Families link$/) do
  expect(page).to have_text("Families")
end

When(/^Hbx Admin clicks on Families link$/) do
  click_link "Families"
  if Settings.aca.state_abbreviation == "DC"
    wait_for_ajax
    find(:xpath, "//*[@id='myTab']/li[2]/ul/li[1]/a/span[1]", :wait => 10).click
    wait_for_ajax
  end
end

Then(/^Hbx Admin should see an Edit APTC \/ CSR link$/) do
  find_link('Edit APTC / CSR').visible?
end

if Settings.aca.state_abbreviation == "DC"
  Then(/^Hbx Admin should not see an Edit APTC \/ CSR link$/) do
    find_link("Edit APTC / CSR")['disabled'].should == 'disabled'
  end
end
