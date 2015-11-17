require 'rails_helper'

feature 'Admin time_log management' do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }
  let(:time_regex) { /\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/ }

  background do
    admin_login
  end

  before do
    FactoryGirl.create_list(:time_log, 2, user: user)
  end

  describe "time_log query" do
    scenario "without params" do
      visit admin_user_time_logs_path(user)
      expect(page).to have_content(time_regex, count: 4) # start_at and end_at
    end

    scenario "with params that have time_logs" do
      visit admin_user_time_logs_path(user, query: { "date(1i)" => Time.now.year, "date(2i)" => Time.now.month })
      expect(page).to have_content(time_regex, count: 4)
    end

    scenario "with params that have no time_logs" do
      visit admin_user_time_logs_path(user, query: { "date(1i)" => Time.now.year - 1, "date(2i)" => Time.now.month })
      expect(page).to_not have_content time_regex
    end
  end
end
