require 'rails_helper'

RSpec.describe Admin::TimeLogsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }

  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    it "assigns variables" do
      get :index, user_id: user.id
      expect(assigns(:user)).to eq user
      expect(assigns(:time_logs).class).to eq TimeLog::ActiveRecord_Associations_CollectionProxy
    end

    it "renders time_logs index" do
      get :index, user_id: user.id
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    let(:time_log) { FactoryGirl.create :time_log, user: user }

    it "assigns variables" do
      get :show, id: time_log
      expect(assigns(:time_log)).to eq time_log
    end

    it "renders time_log show" do
      get :show, id: time_log
      expect(response).to render_template :show
    end
  end

  describe "PATCH update" do
    let(:start_param) { params_from_time(Time.now - 10.minute, :start_at) }
    let(:end_param) { params_from_time(Time.now + 10.minute, :end_at) }

    it "update time_log" do
      time_log = FactoryGirl.create :time_log, user: user
      old_time = time_log.end_at
      expect {
        patch :update, id: time_log.id, time_log: start_param.merge(end_param)
        time_log.reload
      }.to change{ time_log.end_at }.from(old_time).to(Time.zone.local(*end_param.values))
    end

    it "redirects to admin_user_time_logs_path" do
      time_log = FactoryGirl.create :time_log, user: user
      patch :update, id: time_log.id, time_log: start_param.merge(end_param)
      expect(response).to redirect_to admin_time_log_path(time_log)
    end
  end
end
