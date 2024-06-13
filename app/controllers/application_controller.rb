class ApplicationController < ActionController::Base
  before_action :authenticate
  helper_method :logged_in?, :current_user
  
  # 指定の例外の場合は、error500メソッドを呼び出す
  rescue_from Exception, with: :error500
  # 指定の例外の場合は、error404メソッドを呼び出す(TODO: ActionController::RoutingErrorの場合の例外処理(html描画)がなぜか走らない)
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError, with: :error404

  def error404(_error)
    render 'error404', status: 404, formats: [:html]
  end

  def error500(error)
    logger.error [error, *error.backtrace].join("\n")
    # events#editでraiseした場合
    # (byebug) error → RuntimeError
    # error.backtrace ↓ 
    # /Users/xxxxx/perfect/awesome_events/app/controllers/events_controller.rb:25:in `edit'
    # /Users/xxxxx/perfect/awesome_events/vendor/bundle/ruby/3.1.0/gems/actionpack-6.1.7/lib/action_controller/metal/basic_implicit_render.rb:6:in `send_action'
    # /Users/xxxxx/perfect/awesome_events/vendor/bundle/ruby/3.1.0/gems/actionpack-6.1.7/lib/abstract_controller/base.rb:228:in `process_action'
    # 〜
    render 'error500', status: 500, formats: [:html]
  end

  private

  def logged_in?
    !!current_user
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end

  def authenticate
    return if logged_in?
    redirect_to root_path, alert: "ログインしてください"
  end
end
