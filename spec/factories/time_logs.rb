FactoryGirl.define do
  factory :time_log do
    user_id 0
    start_at Time.now - 1
    end_at   Time.now
    original_start_at nil
    original_end_at nil
    modified_by_admin_id nil
  end
end
