
Then(/^.+ should not see fein$/) do
  expect(page).not_to have_content("Fein")
end

Then(/^.+ should see fein$/) do
  expect(page).to have_content("Fein")
end

Then(/^.+ clicks on the broker$/) do
  page.find_link('Acarehouse Inc').trigger('click')
end

When(/^Hbx Admin clicks on the Fake broker$/) do
  click_link "Logistics Inc"
end
