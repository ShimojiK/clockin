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

  describe "#lengthen?" do
    let(:param) do
      time = Time.now + 10.minute
      { "end_at(1i)" => time.year,
        "end_at(2i)" => time.month,
        "end_at(3i)" => time.day,
        "end_at(4i)" => time.hour,
        "end_at(5i)" => time.min }
    end
    it "is true " do
      time_log = FactoryGirl.build :time_log
      expect(time_log.send(:lengthen?, param)).to be true
    end
  end

  describe "#user_updatable?" do
    it "is true" do
      time_log = FactoryGirl.create :time_log_with_user
      expect(time_log.user_updatable?).to be true
    end

    it "is falsy on passing 1 hour and over" do
      time_log = FactoryGirl.create :time_log_with_user, original_end_at: Time.now - 2.hour
      expect(time_log.user_updatable?).to be_falsy
    end

    it "is falsy on non last time_log" do
      user = FactoryGirl.create :user
      time_logs = FactoryGirl.create_list :time_log, 3, user: user
      expect(time_logs.last.user_updatable?).to be true
      expect(time_logs.first.user_updatable?).to be_falsy
    end

    it "is falsy on unfinished time_log" do
      time_log = FactoryGirl.create :time_log_with_user, original_end_at: nil
      expect(time_log.user_updatable?).to be_falsy
    end
  end

  describe "#update_with_create_user_comment" do
    it "creates user comment on success" do
      time_log = FactoryGirl.create :time_log_with_user
      end_at = time_log.end_at - 1.minute
      time = {
        "end_at(1i)" => end_at.year.to_s,
        "end_at(2i)" => end_at.month.to_s,
        "end_at(3i)" => end_at.day.to_s,
        "end_at(4i)" => end_at.hour.to_s,
        "end_at(5i)" => end_at.min.to_s }
      expect {
        time_log.update_with_create_user_comment(time)
      }.to change{ UserComment.count }.from(0).to(1)
    end
  end

  describe "#update_with_create_admin_comment" do
    it "return { alert: nil } on success" do
      admin = FactoryGirl.create :admin
      time_log = FactoryGirl.create :time_log
      end_at = time_log.end_at - 1.minute
      time = {
        "end_at(1i)" => end_at.year.to_s,
        "end_at(2i)" => end_at.month.to_s,
        "end_at(3i)" => end_at.day.to_s,
        "end_at(4i)" => end_at.hour.to_s,
        "end_at(5i)" => end_at.min.to_s }
      expect {
        time_log.update_with_create_admin_comment(time, admin)
      }.to change{ AdminComment.count }.from(0).to(1)
    end
  end
end
