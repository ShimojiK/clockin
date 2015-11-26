require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { FactoryGirl.create :admin }
  let(:user) { FactoryGirl.create :user }

  before do
    session[:admin_id] = admin.id
  end

  describe "GET index" do
    before { get :index }

    it "assigns users" do
      expect(assigns(:users)).to eq [user]
    end

    it { expect(response).to render_template :index }
  end

  describe "GET new" do
    before { get :new }

    it "assigns user" do
      expect(assigns(:user)).to be_a_new User
    end

    it { expect(response).to render_template :new }
  end

  describe "POST create" do
    subject { post :create, user: { name: "yazawa nico", desc: "25252", account: "nico", password: "password" } }

    it "create new user" do
      leads.to change{ User.count }.from(0).to(1)
    end

    it "has name" do
      leads{ User.last.name }.to eq "yazawa nico"
    end

    it "has desc" do
      leads{ User.last.desc }.to eq "25252"
    end

    it { leads{ response }.to redirect_to admin_users_path }
  end

  describe "GET edit" do
    subject { get :edit, id: user.id }

    it "assigns user" do
      leads{ assigns(:user) }.to eq user
    end

    it { leads{ response }.to render_template :edit }
  end

  describe "PATCH update" do
    subject do
        patch :update, id: user.id, user: { name: "ayase eli", desc: "harasyo", account: "eli" }
        user.reload
    end

    it "update user" do
      name = user.name
      leads.to change{ user.name }.from(name).to("ayase eli").and change{ user.desc }.to("harasyo").and change{ user.account }.to("eli")
    end

    it { leads{ response }.to redirect_to admin_user_time_logs_path(user) }
  end
end
