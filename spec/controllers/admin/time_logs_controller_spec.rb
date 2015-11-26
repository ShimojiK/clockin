require 'rails_helper'

RSpec.describe Admin::TimeLogsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }
  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    context "without query" do
      it "assigns variables" do
        get :index, user_id: user.id
        expect(assigns(:user)).to eq user
        expect(assigns(:target_month)).to be_a Time
        expect(assigns(:time_logs)).to be_a TimeLog::ActiveRecord_AssociationRelation
      end

      it "renders time_logs index" do
        get :index, user_id: user.id
        expect(response).to render_template :index
      end
    end

    context "with query" do
      it "assigns variables" do
        MonthlyTimeLogs.create_monthly_time_logs(user, 2015, 10, 10, 12)
        get :index, user_id: user.id, query: { "date(1i)" => 2015, "date(2i)" => 10 }
        expect(assigns(:user)).to eq user
        expect(assigns(:target_month)).to eq Time.zone.local(2015, 10)
        expect(assigns(:time_logs).count).to be 3
      end

      it "renders time_logs index" do
        get :index, user_id: user.id, query: { "date(1i)" => 2015, "date(2i)" => 10 }
        expect(response).to render_template :index
      end
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
      expect(response).to render_template("show")
    end
  end

  describe "PATCH update" do
    let(:start_param) do
      time = Time.now - 10.minute
      { "start_at(1i)" => time.year,
        "start_at(2i)" => time.month,
        "start_at(3i)" => time.day,
        "start_at(4i)" => time.hour,
        "start_at(5i)" => time.min }
    end
    let(:end_param) do
      time = Time.now + 10.minute
      { "end_at(1i)" => time.year,
        "end_at(2i)" => time.month,
        "end_at(3i)" => time.day,
        "end_at(4i)" => time.hour,
        "end_at(5i)" => time.min }
    end

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
