require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_secure_password }

  describe "associations" do
    it { is_expected.to have_many :time_logs }
    it { is_expected.to have_many(:comments).through(:time_logs) }
    it { is_expected.to have_many(:user_comments).through(:time_logs) }
  end

  let(:user) { FactoryGirl.create :user }
  let!(:old_time_log) { FactoryGirl.create :time_log, user: user, start_at: Time.utc(2013) }
  let!(:new_time_log) { FactoryGirl.create :time_log, user: user }
  describe "#newest_year" do
    subject { user.newest_year }
    it "is newest year" do
      expect(subject).to be 2015
    end
  end

  describe "#oldest_year" do
    subject { user.oldest_year }
    it "is oldest year" do
      expect(subject).to be 2013
    end
  end
end
