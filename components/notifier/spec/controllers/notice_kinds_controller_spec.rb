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










end
