FactoryGirl.define do
  factory :time_log do
    user_id              0
    start_at             Time.zone.now - 1.hour
    end_at               Time.zone.now
    original_start_at    Time.zone.now - 1.hour
    original_end_at      Time.zone.now
    modified_by_admin_id nil

    factory :time_log_with_user do
      user
    end
  end
end
