require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }

  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    it "assigns users" do
      get :index
      expect(assigns(:users)).to eq [user]
    end

    it "renders index" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET new" do
    it "assigns user" do
      get :new
      expect(assigns(:user)).to be_a_new User
    end

    it "renders new" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    it "create new user" do
      expect {
        post :create, user: { name: "yazawa nico", desc: "25252", account: "nico", password: "password" }
      }.to change{ User.count }.from(0).to(1)
      expect(User.last.name).to eq "yazawa nico"
      expect(User.last.desc).to eq "25252"
    end

    it "redirects to admin_users_path" do
      post :create, user: { name: "yazawa nico", desc: "25252", account: "nico", password: "password" }
      expect(response).to redirect_to admin_users_path
    end
  end

  describe "GET edit" do
    it "assigns user" do
      get :edit, id: user.id
      expect(assigns(:user)).to eq user
    end

    it "renders edit" do
      get :edit, id: user.id
      expect(response).to render_template :edit
    end
  end

  describe "PATCH update" do
    it "update user" do
      name = user.name
      expect {
        patch :update, id: user.id, user: { name: "ayase eli", desc: "harasyo", account: "eli" }
        user.reload
      }.to change{ user.name }.from(name).to("ayase eli").and change{ user.desc }.to("harasyo").and change{ user.account }.to("eli")
    end

    it "redirects to admin_user_time_logs_path" do
      patch :update, id: user.id, user: { name: "ayase eli", desc: "harasyo", account: "eli" }
      expect(response).to redirect_to admin_user_time_logs_path(user)
    end
  end
end
