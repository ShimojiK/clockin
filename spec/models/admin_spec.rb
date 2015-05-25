require 'rails_helper'

RSpec.describe Admin, type: :model do
  it { is_expected.to have_secure_password }

  describe "associations" do
    it { is_expected.to have_many :comments }
    it { is_expected.to have_many :admin_comments }
  end
end
