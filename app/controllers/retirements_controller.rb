class RetirementsController < ApplicationController
  def new; end

  def create
    if current_user.destroy  # before_destroyコールバックが走る
      reset_session
      redirect_to root_url, notice: "退会完了しました"
    else
      redirect_to new_retirement_url, alert: "退会できませんでした"
    end
  end
end
