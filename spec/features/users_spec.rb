require 'rails_helper'

feature 'User management' do
  let(:user) { FactoryGirl.create :user }

  scenario 'user log in' do
    visit root_path
    fill_in 'アカウント名', with: user.account
    fill_in 'パスワード', with: "password"
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました'
  end
end
