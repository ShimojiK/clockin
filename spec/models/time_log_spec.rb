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

  describe "#user_updatable?" do
    it "is true" do
      time_log = FactoryGirl.build :time_log
      expect(time_log).to be_user_updatable
    end

    it "is false on passing 1 hour and over" do
      time_log = FactoryGirl.build :time_log, original_end_at: Time.now - 2.hour
      expect(time_log).not_to be_user_updatable
    end
  end

  describe "#shorten?" do
    let(:param) do
      time = Time.now
      { "end_at(1i)" => time.year,
        "end_at(2i)" => time.month,
        "end_at(3i)" => time.day,
        "end_at(4i)" => time.hour - 9, #fixme time locale
        "end_at(5i)" => time.min - 10 }
    end
    it "is true " do
      time_log = FactoryGirl.build :time_log
      expect(time_log.shorten?(param)).to be_truthy
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
