require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }

  before do
    session[:admin_id] = admin.id
  end

  describe "POST create" do
    it "creates new admin comment" do
      expect {
        post :create, time_log_id: time_log.id, admin_comment: { body: "admin body" }
      }.to change{ time_log.comments.count }.from(0).to(1)
      expect(time_log.comments.first.body).to eq "admin body"
    end
  end

  describe "PUT update" do
  end
end
