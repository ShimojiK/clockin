require 'factory_girl'

Rake::Task["db:migrate:reset"].invoke

user = FactoryGirl.create(:user)
FactoryGirl.create_list(:time_log, 10, user: user)
