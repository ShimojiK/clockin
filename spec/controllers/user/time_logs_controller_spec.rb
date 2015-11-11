require 'rails_helper'

RSpec.describe User::TimeLogsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }
  before do
    session[:user_id] = user.id
  end

  describe "GET index" do
    context "without query" do
      it "assigns variables" do
        get :index
        expect(assigns(:user)).to eq user
        expect(assigns(:condition)).to be_falsey
        expect(assigns(:target_month)).to be_a Time
        expect(assigns(:time_logs)).to be_a TimeLog::ActiveRecord_AssociationRelation
      end

      it "renders time_logs index" do
        get :index
        expect(response).to render_template("index")
      end
    end

    context "with query" do
      it "assigns variables" do
        MonthlyTimeLogs.create_monthly_time_logs(user, 2015, 10, 10, 12)
        get :index, query: { "date(1i)" => 2015, "date(2i)" => 10 }
        expect(assigns(:user)).to eq user
        expect(assigns(:target_month)).to eq Time.zone.local(2015, 10)
        expect(assigns(:time_logs).count).to be 3
      end

      it "renders time_logs index" do
        get :index, query: { "date(1i)" => 2015, "date(2i)" => 10 }
        expect(response).to render_template("index")
      end
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
    let(:param) do
      time = Time.now - 10.minute
      { "end_at(1i)" => time.year,
        "end_at(2i)" => time.month,
        "end_at(3i)" => time.day,
        "end_at(4i)" => time.hour,
        "end_at(5i)" => time.min }
    end

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
