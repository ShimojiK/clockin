require 'rails_helper'

RSpec.describe User::CommentsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }

  before do
    session[:user_id] = user.id
  end

  describe "POST create" do
    subject { post :create, time_log_id: time_log.id, user_comment: { body: "test body" } }

    it "creates new user comment" do
      leads.to change{ time_log.comments.count }.from(0).to(1)
    end

    it "create body" do
      leads{ time_log.comments.first.body }.to eq "test body"
    end

    it { leads{ response }.to redirect_to time_log_path(time_log) }
  end
end
