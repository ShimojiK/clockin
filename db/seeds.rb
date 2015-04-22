require 'factory_girl'

Rake::Task["db:migrate:reset"].invoke

FactoryGirl.create(:user)
