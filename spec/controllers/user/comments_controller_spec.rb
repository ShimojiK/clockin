require 'rails_helper'

RSpec.describe User::CommentsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }
  before do
    session[:user_id] = user.id
  end

  describe "POST create" do
    it "creates new user comment" do
      expect {
        post :create, time_log_id: time_log.id, user_comment: { body: "test body" }
      }.to change{ time_log.comments.count }.from(0).to(1)
      expect(time_log.comments.first.body).to eq "test body"
    end

    it "redirects to time_log_comments_path" do
      post :create, time_log_id: time_log.id, user_comment: { body: "test body" }
      expect(response).to redirect_to time_log_path(time_log)
    end
  end
end
