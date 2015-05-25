require 'rails_helper'

RSpec.describe UserComment, type: :model do
  describe "associations" do
    it { is_expected.to have_one(:user).through(:time_log) }
    it { is_expected.to belong_to(:ack_admin).class_name("Admin") }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :status }
  end
end
