module LoginMacro
  def user_login
    visit root_path
    fill_in 'アカウント名', with: user.account
    fill_in 'パスワード', with: "password"
    click_button 'ログイン'
  end

  def admin_login
    visit signin_admins_path
    fill_in 'アカウント', with: admin.account
    fill_in 'パスワード', with: "password"
    click_button 'ログイン'
  end
end
