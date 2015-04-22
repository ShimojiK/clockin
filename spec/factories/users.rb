FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "name#{n}" }
    desc "description"
    sequence(:account) {|n| "user#{n}" }
    password "password"
  end
end
