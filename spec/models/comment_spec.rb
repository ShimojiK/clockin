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
    it "return 未承認 when status 0" do
      comment = FactoryGirl.build :comment, status: 0
      expect(comment.status).to be 0
    end

    it "return 承認 when status 1" do
      comment = FactoryGirl.build :comment, status: 1
      expect(comment.status).to be 1
    end
  end
end
