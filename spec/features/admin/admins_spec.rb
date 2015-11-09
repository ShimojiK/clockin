require 'rails_helper'

feature 'Admin management' do
  let(:admin) { FactoryGirl.create :admin }

  background do
    admin_login
  end

  scenario "log in" do
    expect(page).to have_content 'ログインしました'
  end

  scenario "log out" do
    visit admin_users_path
    click_link 'Sign out'
    expect(page).to have_content 'ログアウトしました'
  end

  scenario "create user" do
    visit new_admin_user_path
    fill_in '名前', with: "test-user"
    fill_in '説明', with: "test-description"
    fill_in 'アカウント名', with: "test-account"
    fill_in 'パスワード', with: "test-password"
    click_button '保存'
    expect(page).to have_content 'ユーザを作成しました'
  end
end
