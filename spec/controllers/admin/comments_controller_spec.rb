require 'rails_helper'

RSpec.describe Admin::CommentsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }
  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    it "assigns variables" do
      comments = FactoryGirl.create_list :comment, 5, time_log: time_log
      get :index, time_log_id: time_log.id
      expect(assigns(:time_log)).to eq time_log
      expect(assigns(:comments)).to eq comments
      expect(assigns(:new_comment)).to be_a_new AdminComment
    end

    it "renders admin comments index" do
      get :index, time_log_id: time_log.id
      expect(response).to render_template("index")
    end
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
