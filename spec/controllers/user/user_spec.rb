require 'rails_helper'

RSpec.describe User::UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  context "user signined" do
    before do
      session[:user_id] = user.id
    end

    describe "#signin" do
      it "redirect to root_path" do
        get :signin
        expect(response).to redirect_to root_path
      end
    end
  end

  context "user not signined" do
    describe "#signin" do
      before do
        get :signin
      end

      it "assigns @user" do
        expect(assigns(:user)).to be_a_new User
      end

      it "render signin" do
        expect(response).to render_template(:signin)
      end
    end
  end
end
