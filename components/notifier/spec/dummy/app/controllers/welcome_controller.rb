class WelcomeController < ApplicationController

  def index
    redirect_to notifier.notice_kinds_path
  end
end