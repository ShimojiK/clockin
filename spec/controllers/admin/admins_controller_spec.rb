require 'rails_helper'

RSpec.describe Admin::AdminsController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }

  context "admin signined" do
    before do
      session[:admin_id] = admin.id
    end

    describe "GET signin" do
      it "redirects to admin_users_path" do
        get :signin
        expect(response).to redirect_to admin_users_path
      end
    end
  end

  context "admin not signined" do
    describe "GET signin" do
      before do
        get :signin
      end

      it "assigns admin" do
        expect(assigns(:admin)).to be_a_new Admin
      end

      it "render signin" do
        expect(response).to render_template(:signin)
      end
    end
  end
end
