require 'spec_helper'

feature "admin view payments" do
  background do
    walter = Fabricate(:user, full_name: "Walter Wang", email: 'walterwang@example.com')
    Fabricate(:payment, user: walter, amount: 999)
  end
  scenario "admin can view the payments" do    
    sign_in(Fabricate(:admin))
    visit admin_payments_path
    expect_page_to_have("Walter Wang")
    expect_page_to_have("$9.99")
  end

  scenario "users can not view the payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path
    expect_page_to_not_have("Walter Wang")
    expect_page_to_not_have("$9.99")
  end
end