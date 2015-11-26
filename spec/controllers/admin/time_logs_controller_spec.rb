require 'rails_helper'

RSpec.describe Admin::TimeLogsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }

  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    context "without query" do
      before do
        get :index, user_id: user.id
      end

      it "assigns variables" do
        expect(assigns(:user)).to eq user
        expect(assigns(:target_month)).to be_a Time
        expect(assigns(:time_logs)).to be_a TimeLog::ActiveRecord_AssociationRelation
      end

      it { expect(response).to render_template :index }
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

    context "when success" do
      it "update time_log" do
        leads.to change{ time_log.end_at }.from(old_time).to(Time.zone.local(*end_param.values))
      end

      it { leads.to change{ AdminComment.count }.from(0).to(1) }

      it { leads{ response }.to redirect_to admin_time_log_path(time_log) }
    end

    context "when failure" do
      it "doesn't update time_log"
    end
  end
end
