require 'rails_helper'

RSpec.describe Admin::AdminsController, type: :controller do
  let!(:admin) { FactoryGirl.create :admin }
  let(:correct_post) { post :create, admin: { account: admin.account, password: "password" } }
  let(:wrong_post) { post :create, admin: { account: admin.account, password: "wrong_password" } }

  context "when not signined" do
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

    describe "POST create" do
      subject { response }

      context "with correct password" do
        before { correct_post }
        it { is_expected.to redirect_to admin_users_path }
      end

      context "with wrong password" do
        before { wrong_post }
        it { is_expected.to redirect_to signin_admins_path }
      end
    end

    describe "DELETE signout" do
      before { delete :signout }
      subject { response }
      it { is_expected.to redirect_to signin_admins_path }
    end
  end

  context "when signined" do
    before do
      session[:admin_id] = admin.id
    end

    describe "GET signin" do
      before { get :signin }
      subject { response }
      it { is_expected.to redirect_to admin_users_path }
    end

    describe "POST create" do
      subject { response }

      context "with correct password" do
        before { correct_post }
        it { is_expected.to redirect_to admin_users_path }
        it "assigns session" do
          expect(session[:admin_id]).to eq admin.id
        end
      end

      context "with wrong password" do
        before { wrong_post }
        it { is_expected.to redirect_to signin_admins_path }
      end
    end

    describe "DELETE signout" do
      before { delete :signout }
      it { expect(response).to redirect_to signin_admins_path }
      it "resets session" do
        expect(session[:admin_id]).to be_nil
      end
    end
  end

end
