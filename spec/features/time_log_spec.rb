require 'rails_helper'

feature 'TimeLog management' do
  let(:user) { FactoryGirl.create :user }

  background do
    user_login
  end

  scenario "clock in" do
    visit time_logs_path
    expect {
      click_button 'Start'
    }.to change{user.time_logs.count}.from(0).to(1)
    expect(user.time_logs.first.start_at).not_to be_nil
    expect(user.time_logs.first.end_at).to be_nil
  end

  scenario "clock out" do
    visit time_logs_path
    click_button 'Start'
    click_button 'Stop'
    expect(user.time_logs.first.end_at).not_to be_nil
  end
end
