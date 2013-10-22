Given /^I'm logged in$/ do
  user = FactoryGirl.create(:user)
  visit("/users/sign_in")
  within("#new_user") do
    fill_in("user[email]", :with => user.email )
    fill_in("user[password]", :with => user.password )
  end
  click_button "Sign in"
end
