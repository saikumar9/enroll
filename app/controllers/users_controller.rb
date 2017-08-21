class UsersController < ApplicationController
  before_filter :confirm_existing_password, only: [:change_password]

  def confirm_lock
    params.permit!
    @user_id  = params[:user_action_id]
  end

  def lockable
    authorize User, :lockable?
    user.update_lockable
    redirect_to user_account_index_exchanges_hbx_profiles_url, notice: "User #{user.person.full_name} is successfully #{user.lockable_notice}."
  rescue Exception => e
    redirect_to user_account_index_exchanges_hbx_profiles_url, alert: "You are not authorized for this action."
  end

  def change_password
    user.password = params[:user][:new_password]
    user.password_confirmation = params[:user][:password_confirmation]
    if user.save!
      flash[:success] = "Password successfully changed"
    else
      flash[:error] = "We encountered a problem trying to update your password, please try again"
    end
    redirect_to personal_insured_families_path
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def confirm_existing_password
    unless user.valid_password? params[:user][:password]
      flash[:error] = "That password does not match the one we have stored"
      redirect_to personal_insured_families_path
      return false
    end
  end
end
