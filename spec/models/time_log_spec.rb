require 'rails_helper'

RSpec.describe TimeLog, type: :model do
  describe "associations" do
    it { is_expected.to belong_to :user }
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :user_comments }
    it { is_expected.to have_many :admin_comments }
  end

  describe "validations" do
    subject { FactoryGirl.build :time_log, start_at: Time.now + 1.hour }
    it { is_expected.not_to be_valid }
  end

  describe "#shorten?" do
    let(:param) do
      time = Time.now - 9.hour - 10.minute # set locale and shorten
      { "end_at(1i)" => time.year,
        "end_at(2i)" => time.month,
        "end_at(3i)" => time.day,
        "end_at(4i)" => time.hour,
        "end_at(5i)" => time.min }
    end
    it "is true " do
      time_log = FactoryGirl.build :time_log
      expect(time_log.shorten?(param)).to be_truthy
    end
  end

  describe "#user_updatable_status" do
    it "is :ok" do
      time_log = FactoryGirl.create :time_log_with_user
      expect(time_log.user_updatable_status).to be :ok
    end

    it "is :time_over on passing 1 hour and over" do
      time_log = FactoryGirl.create :time_log_with_user, original_end_at: Time.now - 2.hour
      expect(time_log.user_updatable_status).to be :time_over
    end

    it "is :non_target on non last time_log" do
      user = FactoryGirl.create :user
      time_logs = FactoryGirl.create_list :time_log, 3, user: user
      expect(time_logs.last.user_updatable_status).to be :ok
      expect(time_logs.first.user_updatable_status).to be :non_target
    end

    it "is :uncomplete on unfinished time_log" do
      time_log = FactoryGirl.create :time_log_with_user, original_end_at: nil
      expect(time_log.user_updatable_status).to be :uncomplete
    end
  end

  describe "#update_with_create_user_comment" do
    it "return { alert: nil } on success" do
      time_log = FactoryGirl.create :time_log
      old_end = time_log.end_at
      expect(time_log.update_with_create_user_comment({ end_at: (old_end - 1.minute) }, old_end)).to eq ({ alert: nil })
    end
  end

  describe "#update_with_create_admin_comment" do
    it "return { alert: nil } on success" do
      admin = FactoryGirl.create :admin
      time_log = FactoryGirl.create :time_log
      old_end = time_log.end_at
      expect(time_log.update_with_create_admin_comment({ end_at: (old_end - 1.minute) }, old_end, admin)).to eq ({ alert: nil })
    end
  end
end
