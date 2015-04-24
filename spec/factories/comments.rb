FactoryGirl.define do
  factory :comment do
    time_log nil
    sequence(:body) {|n| "comment-#{n}" }
    type "Comment"

    factory :user_comment, parent: :comment, class: :user_comment do
      ack_admin nil
      status 1
      type "UserComment"
    end

    factory :admin_comment, parent: :comment, class: :admin_comment do
      admin nil
      type "AdminComment"
    end
  end
end
