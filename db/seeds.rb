require 'factory_girl'
Dir[Rails.root.join('spec/factories/**/*.rb')].each {|f| require f }

Rake::Task["db:migrate:reset"].invoke

FactoryGirl.create(:admin)

user = FactoryGirl.create(:user)
10.times do |i|
  time_log = FactoryGirl.create(:time_log, user: user)
  FactoryGirl.create_list(:user_comment, 5, time_log: time_log)
end
