When(/^the Hbx Admin clicks on the Ma logo link$/) do
  find(:xpath, '//*[@id="ma_logo"]/img').trigger('click')
end

Then(/^it should redirect to Ma Health connector website$/) do
  wait_for_ajax(3,2)
  expect(page).to have_content("Health Connector for Business")
end