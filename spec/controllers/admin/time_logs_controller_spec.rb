require 'rails_helper'

RSpec.describe Admin::TimeLogsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }

  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    before do
      get :index, user_id: user.id
    end

    it "assigns variables" do
      expect(assigns(:user)).to eq user
      expect(assigns(:time_logs).class).to eq TimeLog::ActiveRecord_Associations_CollectionProxy
    end

    it { expect(response).to render_template :index }
  end

  describe "GET show" do
    let(:time_log) { FactoryGirl.create :time_log, user: user }

    before do
      get :show, id: time_log
    end

    it "assigns variables" do
      expect(assigns(:time_log)).to eq time_log
    end

    it { expect(response).to render_template :show }
  end

  describe "PATCH update" do
    let(:start_param) { params_from_time(Time.now - 10.minute, :start_at) }
    let(:end_param) { params_from_time(Time.now + 10.minute, :end_at) }
    let(:time_log) { FactoryGirl.create :time_log, user: user }
    let(:old_time) { old_time = time_log.end_at }

    subject do
      patch :update, id: time_log.id, time_log: start_param.merge(end_param)
      time_log.reload
    end

    it "update time_log" do
      leads.to change{ time_log.end_at }.from(old_time).to(Time.zone.local(*end_param.values))
    end

    it { leads{ response }.to redirect_to admin_time_log_path(time_log) }
  end
end
