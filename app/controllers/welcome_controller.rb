class WelcomeController < ApplicationController
  skip_before_action :authenticate

  def index
    # 検索機能実装前
    # @events = Event.page(params[:page]).per(2).where("start_at > ?", Time.zone.now).order(:start_at)

    # 検索機能実装後
    # (byebug) params
    #<ActionController::Parameters {"event_search_form"=>{"keyword"=>"勉強", "start_at"=>"2024-06-11T18:19"}, "commit"=>"検索", "controller"=>"welcome", "action"=>"index"} permitted: false>
    # (byebug) event_search_form_params
    #<ActionController::Parameters {"keyword"=>"勉強", "start_at"=>"2024-06-11T18:19", "page"=>nil} permitted: true>
    @event_search_form = EventSearchForm.new(event_search_form_params)
    @events = @event_search_form.search
  end

  private

  def event_search_form_params
    params.fetch(:event_search_form, {}).permit(:keyword, :start_at).merge(page: params[:page])
  end
end
