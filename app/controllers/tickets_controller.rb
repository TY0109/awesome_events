class TicketsController < ApplicationController
  def new
    # ログインユーザがモーダルではなく、events/event_id/tickets/:idのURLを直打ちでアクセスしてきた時の対応
    raise ActionController::RoutingError, "ログイン状態で TicketsControler#new にアクセス"
    # しかし、applicationコントローラで以下の対応を行なっているので、不要では？
    # rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404
  end

  def create
    event = Event.find(params[:event_id])
    @ticket = current_user.tickets.build do |t|
      t.event = event
      t.comment = params[:ticket][:comment]
    end
    # cf 以下でもOK
    # @ticket = current_user.tickets.build(comment: params[:ticket][:comment])
    # @ticket.event = event
    # or
    # @ticket = event.tickets.build(comment: params[:ticket][:comment])
    # @ticket.user = current_user

    if @ticket.save
      redirect_to event, notice: "このイベントに参加表明しました"
    # バリデーションエラー時は、create.js.erbでエラーメッセージを描画
    end
  end

  def destroy
    ticket = current_user.tickets.find_by!(event_id: params[:event_id])
    ticket.destroy!
    redirect_to event_path(params[:event_id]), notice: "このイベントの参加をキャンセルしました"
  end
end
