require 'rails_helper'

feature "time_logs query" do
  let(:user) { FactoryGirl.create :user }
  let(:time_regex) { /\d{4}-\d{2}-\d{2} \d{2}:\d{2}/ }

  before do
    user_login
    FactoryGirl.create_list(:time_log, 2, user: user)
  end

  scenario "without params" do
    visit time_logs_path
    expect(page).to have_content(time_regex, count: 4)
  end

  scenario "with params have time_logs" do
    visit time_logs_path(query: { "date(1i)" => Time.now.year, "date(2i)" => Time.now.month })
    expect(page).to have_content(time_regex, count: 4)
  end

  scenario "with params have no time_logs" do
    visit time_logs_path(query: { "date(1i)" => Time.now.year - 1, "date(2i)" => Time.now.month })
    expect(page).to_not have_content time_regex
  end
end
