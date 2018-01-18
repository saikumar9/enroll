require 'rails_helper'

RSpec.describe Notifier::NoticeKindsController, :type => :controller do
  routes { Notifier::Engine.routes }


  describe "GET # index" do

    context "assigns global variables" do
      let!(:person) { FactoryGirl.create(:person) }
      let!(:user) { FactoryGirl.create(:user, :hbx_staff, person: person) }
      let!(:user_wth_no_person) { FactoryGirl.create(:user) }

      it "should invoke the action" do
        sign_in(user)
        get :index
        expect(assigns(:notice_kinds))
        expect(assigns(:datatable)).to be_kind_of(Effective::Datatables::NoticesDatatable)
        expect(response).to render_template("index")
        expect(response.content_type).to eq "text/html"
      end

      it "should not invoke the index action" do
        sign_in(user_wth_no_person)
        get :index
        expect(response).to redirect_to("/")
      end
    end
  end

  describe "GET # show" do
    let!(:person) { FactoryGirl.create(:person) }
    let!(:user) { FactoryGirl.create(:user, :hbx_staff, person: person) }
    let!(:user_wth_no_person) { FactoryGirl.create(:user) }

    context "re-direct to notice_kinds_path" do
      subject { get :show, :id => 'upload_notices' }

      it "should invoke show action" do
        sign_in(user)
        expect(subject).to redirect_to(notice_kinds_url)
        expect(response.content_type).to eq "text/html"
      end
    end

    context "not to re-direct to notice_kinds_path" do
      subject { get :show, :id => "rspec" }

      it "should not invoke action" do
        sign_in(user)
        expect(subject).not_to redirect_to(notice_kinds_url)
        expect(response).to render_template('show')
      end
    end
  end

  describe "GET # new" do
    let!(:person) { FactoryGirl.create(:person) }
    let!(:user) { FactoryGirl.create(:user, :hbx_staff, person: person) }
    let!(:user_wth_no_person) { FactoryGirl.create(:user) }
    context "invoke the action"do
     it "should assigns global variables" do
       sign_in(user)
       get :new, :format => 'js'
       expect(assigns(:notice_kind)).to be_kind_of(Notifier::NoticeKind)
     end

      it "should assigns temlate to notice kind" do
        sign_in(user)
        get :new, :format => 'js'
        expect(assigns(:notice_kind)).to be_a(Notifier::NoticeKind)
        expect(assigns(:notice_kind).template).not_to be_nil
        expect(response).to have_http_status(:success)
        expect(response).to render_template('new')
      end
    end
  end


  describe 'Get # edit' do
    let!(:person) { FactoryGirl.create(:person) }
    let!(:user) { FactoryGirl.create(:user, :hbx_staff, person: person) }
    let!(:user_wth_no_person) { FactoryGirl.create(:user) }
    context 'invoke edit action' do
      it 'should assign notice_kind' do
        sign_in(user)
        allow(Notifier::NoticeKind).to receive(:find).with("rspec").and_return("notice_kind")
        get :edit, id: "rspec", :format => 'js'
       expect(response).to render_template('edit')
      end
    end
  end

  describe 'Post Create' do
    let!(:person) { FactoryGirl.create(:person) }
    let!(:user) { FactoryGirl.create(:user, :hbx_staff, person: person) }
    let!(:user_wth_no_person) { FactoryGirl.create(:user) }
    let!(:valid_params) { val = FactoryGirl.attributes_for(:notifier_notice_kind)
                          val.merge!("template" => {"raw_body"=>"<p>Rspec-template-body-goes-here</p>\r\n"})
    }

    context 'with valid attributes' do
      it 'should create new notice_kind' do
        sign_in(user)
        expect{
          post :create, notice_kind: valid_params
        }.to change(Notifier::NoticeKind, :count).by(1)
      end

      it 'should create new notice_kind and redirect' do
        sign_in(user)
        post :create, notice_kind: valid_params
        expect(flash[:notice]).to match /Notice created successfully/
        expect(response).to redirect_to(notice_kinds_url)
      end
    end

    context 'with invalid attributes' do
      let!(:notice_kind) { FactoryGirl.create(:notifier_notice_kind) }
      let!(:invalid_attributes) { { 'notice_kind' => { 'notice_number': notice_kind.notice_number}}
      }
      it 'should not create new notice kind' do
        sign_in(user)
        expect { post :create, notice_kind: invalid_attributes }.not_to change(Notifier::NoticeKind, :count)
      end

      it 'should render index view' do
        sign_in(user)
        post :create, notice_kind: invalid_attributes
        expect(response).to render_template 'index'
      end

    end

  end

  describe 'PUT update' do
    let!(:person) { FactoryGirl.create(:person) }
    let!(:user) { FactoryGirl.create(:user, :hbx_staff, person: person) }
    let!(:user_wth_no_person) { FactoryGirl.create(:user) }
    let!(:notice_kind) { FactoryGirl.create(:notifier_notice_kind) }

    let!(:valid_params) { val = FactoryGirl.attributes_for(:notifier_notice_kind)
                          val.merge!("template" => {"raw_body" => "<p>Rspec-template-body-goes-here</p>\r\n"})
    }

    it 'should update the template raw body' do
      sign_in(user)
      put :update, id: notice_kind.id.to_s, notice_kind: valid_params
      expect(response).to redirect_to(notice_kinds_url)
      expect(notice_kind.title).to eq valid_params[:title]
      expect(flash[:notice]).to match /Notice content updated successfully/
    end
  end
















end
