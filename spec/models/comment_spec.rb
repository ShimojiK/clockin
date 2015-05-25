require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of :body }
    it { is_expected.to validate_presence_of :type }
  end

  describe "associations" do
    it { is_expected.to belong_to :time_log }
  end
end
