class EventsController < ApplicationController
  skip_before_action :authenticate, only: :show

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)
    if @event.save
      redirect_to @event, notice: '作成しました'
    # バリデーションエラー時は、create.js.erbでエラーメッセージを描画
    end
  end

  def show
    @event = Event.find(params[:id])
    @tickets = @event.tickets.includes(:user).order(:created_at)
    @ticket =  current_user&.tickets&.find_by(event: @event) # current_user && current_user.tickets.find_by(event: @event)ではやや冗長
  end

  def edit
    @event = current_user.created_events.find(params[:id])
  end

  def update
    @event = current_user.created_events.find(params[:id])
    if @event.update(event_params)
      redirect_to @event, notice: "更新しました"
    # バリデーションエラー時は、update.js.erbでエラーメッセージを描画
    # 非同期でエラーメッセージを描画することによってページ遷移を避けることができるので、以下の問題も解消される
    # https://railsguides.jp/active_storage_overview.html#%E3%83%95%E3%82%A9%E3%83%BC%E3%83%A0%E3%81%AE%E3%83%90%E3%83%AA%E3%83%87%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3
    end
  end

  def destroy
    @event = current_user.created_events.find(params[:id])
    @event.destroy!
    redirect_to root_path, notice: "削除しました"
  end

  private

  def event_params
    params.require(:event).permit(
      :name, :place, :image, :remove_image, :content, :start_at, :end_at
    )
  end
end
