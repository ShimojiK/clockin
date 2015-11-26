require 'rails_helper'

RSpec.describe TimeLog, type: :model do
  let(:user) { FactoryGirl.create :user }

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

  describe "#updatable_check" do
    let(:user) { FactoryGirl.create :user }
    let(:time_log) { FactoryGirl.create :time_log, user: user }
    subject { time_log.errors.count }

    context "when valid" do
      it { is_expected.to be_zero }
    end

    context "when invalid" do
      context "lengthen" do
        before do
          time_log.updatable_check(params_from_time(Time.zone.now + 1.hour, :end_at))
        end
        it { is_expected.not_to be_zero }
      end

      context "unfinished" do
        before do
          time_log.original_end_at = nil
          time_log.updatable_check
        end
        it { is_expected.not_to be_zero }
      end

      context "non last" do
        before do
          time_log
          FactoryGirl.create :time_log, user: user
          time_log.updatable_check
        end
        it { is_expected.not_to be_zero }
      end

      context "time up" do
        before do
          time_log.original_end_at = Time.now - 2.hour
          time_log.updatable_check
        end
        it { is_expected.not_to be_zero }
      end
    end
  end

  describe "#user_updatable?" do
    let(:time_log) { FactoryGirl.create :time_log_with_user }
    subject { time_log.user_updatable? }

    context "when updatable" do
      it { is_expected.to be_truthy }
    end

    context "when passing 1 hour" do
      before { time_log.original_end_at = Time.now - 2.hour }
      it { is_expected.to be_falsy }
    end

    context "when non last time_log" do
      let(:time_logs) { FactoryGirl.create_list :time_log, 3, user: user }
      subject { time_logs.first.user_updatable? }
      it { is_expected.to be_falsy }
    end

    context "when unfinished time_log" do
      before { time_log.original_end_at = nil }
      it { is_expected.to be_falsy }
    end
  end

  describe "#update_with_create_user_comment" do
    let(:time_log) { FactoryGirl.create :time_log_with_user }
    let(:end_at) { time_log.end_at - 1.minute }
    let(:time) { params_from_time(time_log.end_at - 1.minute, :end_at) }
    subject { time_log.update_with_create_user_comment(time) }

    it { leads.to change{ UserComment.count }.from(0).to(1) }
  end

  describe "#update_with_create_admin_comment" do
    let(:admin) { FactoryGirl.create :admin }
    let(:time_log) { FactoryGirl.create :time_log }
    let(:time) { params_from_time(time_log.end_at - 1.minute, :end_at) }
    subject { time_log.update_with_create_admin_comment(time, admin) }

    it { leads.to change{ AdminComment.count }.from(0).to(1) }
  end
end
