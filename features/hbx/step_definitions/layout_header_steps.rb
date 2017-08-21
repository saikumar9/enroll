When(/^the Hbx Admin clicks on the Ma logo link$/) do
  find(:xpath, '//*[@id="ma_logo"]/img').trigger('click')
end

Then(/^it should redirect to Ma Health connector website$/) do
  expect(page).to have_content("Welcome to Health Connector for Business")
end