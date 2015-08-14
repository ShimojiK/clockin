require 'rails_helper'

feature 'User management' do
  let(:user) { FactoryGirl.create :user }

  background do
    visit root_path
    fill_in 'アカウント名', with: user.account
    fill_in 'パスワード', with: "password"
    click_button 'ログイン'
  end

  scenario 'user log in' do
    expect(page).to have_content 'ログインしました'
  end

end

feature "New user management" do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.build :user }

  scenario "required to change password" do
    # login admin
    visit signin_admins_path
    fill_in 'アカウント', with: admin.account
    fill_in 'パスワード', with: "password"
    click_button 'ログイン'

    # create user
    visit new_admin_user_path
    fill_in '名前', with: user.name
    fill_in '説明', with: user.desc
    fill_in 'アカウント名', with: user.account
    fill_in 'パスワード', with: "password"
    click_button '保存'

    # logout
    visit admin_users_path
    click_link 'signout'

    # login user
    visit root_path
    fill_in 'アカウント名', with: user.account
    fill_in 'パスワード', with: "password"
    click_button 'ログイン'

    # change password
    fill_in '新しいパスワード', with: "new-password"
    click_button '更新'

    expect(page).to have_content 'パスワードを更新しました'
  end
end
