FactoryGirl.define do
  factory :time_log do
    user_id              0
    start_at             Time.now - 1.hour
    end_at               Time.now
    original_start_at    Time.now - 1.hour
    original_end_at      Time.now
    modified_by_admin_id nil
  end
end
