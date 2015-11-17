require 'rails_helper'

RSpec.describe User::TimeLogsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }
  before do
    session[:user_id] = user.id
  end

  describe "GET index" do
    it "assigns variables" do
      get :index
      expect(assigns(:condition)).to be_falsey
      expect(assigns(:time_logs).class).to eq TimeLog::ActiveRecord_Associations_CollectionProxy
    end

    it "renders time_logs index" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET show" do
    it "assigns variables" do
      get :show, id: time_log
      expect(assigns(:time_log)).to eq time_log
    end

    it "renders time_logs show" do
      get :show, id: time_log
      expect(response).to render_template("show")
    end
  end

  describe "POST create" do
    it "creates time_log" do
      expect {
        post :create, time_log: { end_at: Time.now }
      }.to change{ TimeLog.count }.from(0).to(1)
    end

    it "redirects to time_logs_path" do
      post :create, time_log: { end_at: Time.now }
      expect(response).to redirect_to time_logs_path
    end
  end

  describe "PATCH update" do
    let(:param) { params_from_time(Time.now - 10.minute, :end_at) }

    it "updates time_log" do
      time_log = FactoryGirl.create :time_log, user: user
      old_time = time_log.end_at
      expect {
        patch :update, id: time_log.id, time_log: param
        time_log.reload
      }.to change{ time_log.end_at }.from(old_time).to(Time.zone.local(*param.values))
    end

    it "redirects to time_log_path" do
      time_log = FactoryGirl.create :time_log, user: user
      patch :update, id: time_log.id, time_log: param
      expect(response).to redirect_to time_log_path(time_log)
    end
  end
end
