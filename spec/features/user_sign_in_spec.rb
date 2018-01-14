require 'spec_helper'

feature "user sign in" do
  scenario "with valid email and password" do
    riddle_bear = Fabricate(:user, full_name: "Riddle Bear")
    sign_in(riddle_bear)
    expect_page_to_have riddle_bear.full_name
  end

  scenario "with deactivated user" do
    walter = Fabricate(:user,full_name: "walter", active: false)
    sign_in(walter)
    expect_page_to_not_have("walter")
    expect_page_to_have("Your account has been suspended, please contact customer services")
  end
end