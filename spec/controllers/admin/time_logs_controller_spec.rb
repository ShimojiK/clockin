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

  describe "PATCH update" do
    let(:start_param) do
      time = Time.now - 9.hour - 10.minute # set locale and change
      { "start_at(1i)" => time.year,
        "start_at(2i)" => time.month,
        "start_at(3i)" => time.day,
        "start_at(4i)" => time.hour,
        "start_at(5i)" => time.min }
    end
    let(:end_param) do
      time = Time.now - 9.hour + 10.minute # set locale and change
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
      expect(response).to redirect_to admin_time_log_comments_path(time_log)
    end
  end
end
