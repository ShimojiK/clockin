require 'rails_helper'

feature 'User management' do
  let(:user) { FactoryGirl.create :user }

  background do
    user_login
  end

  scenario "user log in" do
    expect(page).to have_content 'ログインしました'
  end

end

feature "New user management" do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.build :user }

  scenario "required to change password" do
    # login admin
    admin_login

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
    user_login

    # change password
    fill_in '新しいパスワード', with: "new-password"
    click_button '更新'

    expect(page).to have_content 'パスワードを更新しました'
  end
end
