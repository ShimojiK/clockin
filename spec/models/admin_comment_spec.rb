require 'rails_helper'

RSpec.describe AdminComment, type: :model do
  describe "associations" do
    it { is_expected.to belong_to :admin }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :admin_id }
  end
end
