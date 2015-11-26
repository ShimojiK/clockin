require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }
  let!(:time_log) { FactoryGirl.create :time_log, user: user }

  before do
    session[:admin_id] = admin.id
  end

  describe "POST create" do
    subject { post :create, time_log_id: time_log.id, admin_comment: { body: "admin body" } }

    it "create comment body" do
      leads{ time_log.comments.first.body }.to eq "admin body"
    end
  end

  describe "PUT update" do
    let(:user_comment) { FactoryGirl.create :user_comment, time_log: time_log }
    subject do
      patch :update, id: user_comment.id, admin_comment: { status: 1 }
      user_comment.reload
    end

    it "updates status" do
      leads.to change{ user_comment.status }.from(0).to(1)
    end

    it "updates ack_admin_id" do
      leads{ user_comment.ack_admin_id }.to eq admin.id
    end
  end
end
