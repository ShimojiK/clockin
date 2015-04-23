FactoryGirl.define do
  factory :admin do
    sequence(:account) {|n| "admin#{n}" }
    password "password"
  end
end
