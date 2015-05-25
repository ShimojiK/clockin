require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to have_secure_password }

  describe "associations" do
    it { is_expected.to have_many :time_logs }
    it { is_expected.to have_many(:comments).through(:time_logs) }
    it { is_expected.to have_many(:user_comments).through(:time_logs) }
  end
end
