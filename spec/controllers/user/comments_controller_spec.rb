require 'rails_helper'

RSpec.describe User::CommentsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }
  before do
    session[:user_id] = user.id
  end

  describe "GET index" do
    it "assigns variables" do
      comments = FactoryGirl.create_list :comment, 5, time_log: time_log
      get :index, time_log_id: time_log.id
      expect(assigns(:time_log)).to eq time_log
      expect(assigns(:comments)).to eq comments
      expect(assigns(:new_comment)).to be_a_new UserComment
    end

    it "renders comments index" do
      get :index, time_log_id: time_log.id
      expect(response).to render_template("index")
    end
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
      expect(response).to redirect_to time_log_comments_path(time_log)
    end
  end
end
