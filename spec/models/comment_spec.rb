require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :type }
  end

  describe "associations" do
    it { is_expected.to belong_to :time_log }
  end

  describe "#state" do
    let(:comment) { FactoryGirl.build :comment }
    subject { comment.state }

    context "when status 0" do
      before { comment.status = 0 }
      it { is_expected.to eq "未承認" }
    end

    context "when status 1" do
      before { comment.status = 1 }
      it { is_expected.to eq "承認" }
    end

    context "when unknown status" do
      before { comment.status = 25 }
      it { is_expected.to eq "error" }
    end
  end
end
