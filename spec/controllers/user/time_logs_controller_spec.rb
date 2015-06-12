require 'rails_helper'

RSpec.describe User::TimeLogsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
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
      time = Time.now - 9.hour - 10.minute # set locale and shorten
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

    it "redirects to time_log_comment_path" do
      time_log = FactoryGirl.create :time_log, user: user
      patch :update, id: time_log.id, time_log: param
      expect(response).to redirect_to time_log_comments_path(time_log)
    end
  end
end
