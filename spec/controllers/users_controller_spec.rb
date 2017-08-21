require 'rails_helper'

describe UsersController do

  describe '.change_password' do
    let(:user) { build(:user, id: '1', password: 'Complex!@#$') }
    let(:original_password) { 'Complex!@#$' }
    before do
      allow(User).to receive(:find).with('1').and_return(user)
      sign_in(user)
      post :change_password, { id: '1', user: { password: original_password, new_password: 'S0methingElse!@#$', password_confirmation: 'S0methingElse!@#$'} }
    end

    context "with a matching current password" do
      it 'changes the password' do
        expect(user.valid_password? 'S0methingElse!@#$').to be_truthy
      end
    end

    context "with an invalid current password" do
      let(:original_password) { 'Potato' }
      it 'does not change the password' do
        expect(user.valid_password? 'Complex!@#$').to be_truthy
      end
    end
  end

  describe ".lockable" do
    let(:admin) { instance_double(User) }
    let(:locked_at) { nil }
    let(:user) { build(:user, id: '1', locked_at: locked_at) }

    before do
      allow_any_instance_of(UsersController).to receive(:authorize).with(User, :lockable?).and_raise(Pundit::NotAuthorizedError)
      allow(User).to receive(:find).with('1').and_return(user)
      allow(user).to receive(:update_lockable).and_call_original
      allow(user).to receive(:lock_access!)
      allow(user).to receive(:unlock_access!)
    end

    context 'When admin is not authorized for lockable then User status can not be changed' do
      before do
        sign_in(admin)
        get :lockable, id: user.id
      end

      it "does not lock the user" do
        expect(user).to_not have_received(:lock_access!)
        expect(user).to_not have_received(:unlock_access!)
        expect(response).to redirect_to(user_account_index_exchanges_hbx_profiles_url)
      end
    end

    context 'When admin is authorized for lockable then User status can be locked' do
      before do
        allow_any_instance_of(UsersController).to receive(:authorize).with(User, :lockable?).and_return(true)
        sign_in(admin)
        get :lockable, id: user.id
      end
      it "locks the user" do
        expect(user).to have_received(:lock_access!)
        expect(response).to redirect_to(user_account_index_exchanges_hbx_profiles_url)
      end
    end

    context 'When admin is authorized and User status is locked then it should be unlocked' do
      let(:locked_at) { Date.today }

      before do
        allow_any_instance_of(UsersController).to receive(:authorize).with(User, :lockable?).and_return(true)
        sign_in(admin)
        get :lockable, id: user.id
      end

      it "unlocks the user" do
        expect(user).to have_received(:unlock_access!)
        expect(response).to redirect_to(user_account_index_exchanges_hbx_profiles_url)
      end
    end
  end
end
