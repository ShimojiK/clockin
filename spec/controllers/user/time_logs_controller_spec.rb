require 'rails_helper'

RSpec.describe User::TimeLogsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:time_log) { FactoryGirl.create :time_log, user: user }

  before do
    session[:user_id] = user.id
  end

  describe "GET index" do
    context "without query" do
      before { get :index }

      it "assigns variables" do
        expect(assigns(:user)).to eq user
        expect(assigns(:condition)).to be_falsey
        expect(assigns(:target_month)).to be_a Time
        expect(assigns(:time_logs)).to be_a TimeLog::ActiveRecord_AssociationRelation
      end

      it { expect(response).to render_template("index") }
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
    before { get :show, id: time_log }

    it "assigns variables" do
      expect(assigns(:time_log)).to eq time_log
    end

    it { expect(response).to render_template("show") }
  end

  describe "POST create" do
    subject { post :create, time_log: { end_at: Time.zone.now } }

    context "when start" do
      it { leads.to change{ TimeLog.count }.from(0).to(1) }

      it "updates start_at" do
        leads{ TimeLog.first.start_at }.to be_a Time
      end

      it "doesn't update end_at" do
        leads{ TimeLog.first.end_at }.to be_nil
      end

      it { leads{ response }.to redirect_to time_logs_path }
    end

    context "when end" do
      before { post :create, time_log: { end_at: Time.zone.now } }

      it { leads.to_not change{ TimeLog.count } }

      it "remains start_at" do
        leads{ TimeLog.first.start_at.to_s }.to eq Time.zone.now.to_s
      end

      it "updates end_at" do
        leads{ TimeLog.first.end_at.to_s }.to eq Time.zone.now.to_s
      end
    end
  end

  describe "PATCH update" do
    let(:param) { params_from_time(Time.zone.now - 10.minute, :end_at) }
    let(:old_time) { time_log.end_at }
    subject do
      patch :update, id: time_log.id, time_log: param
      time_log.reload
    end

    context "when success" do
      it "updates time_log" do
        leads.to change{ time_log.end_at }.from(old_time).to(Time.zone.local(*param.values))
      end

      it "create user comment" do
        leads.to change{ UserComment.count }.from(0).to(1)
      end

      it { leads{ response }.to redirect_to time_log_path(time_log) }
    end

    context "when failuer" do
      it "doesn't update time_log"
    end
  end
end
