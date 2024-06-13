class EventSearchForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # 型やデフォルト値を持たせたいなら attribute をつかう
  # そうでないなら attr_accessor をつかう
  # cf https://zenn.dev/ndjndj/articles/154cc0701bc65

  attribute :keyword, :string
  attribute :page, :integer
  # start_atについては、さらにカスタマイズしたいので、getter, setterを使用

  # welcome#indexの中で呼び出される
  def search
    # attributeでstart_atに値をセットする場合( attribute :start_at, :datetime, default: -> { Time.current } )
    # (byebug) start_at
    # 2024-06-11 20:56:07 +0900
    # → start_atは、Timeオブジェクト

    # setterでstart_atに値をセットする場合
    # (byebug) start_at
    # Tue, 11 Jun 2024 20:56:07.000000000 JST +09:00
    # → start_atは、TimeWithZoneオブジェクト

    # 今回、現在日時としてTime.now(Timeオブジェクト)ではなく、Time.current(TimeWithZoneオブジェクト)を使用したい。
    # それに合わせるために、attributeではなく、setterを使って設定を行う

    Event.search(
      keyword_for_search,
      where: { start_at: { gt: start_at } },
      page: page,
      per_page: 10
    )
  end

  # getterメソッド
  def start_at
    puts "where: { start_at: { gt: start_at } }でstart_atカラムの値へのアクセスで呼び出される"
    @start_at || Time.current
  end

  # setterメソッド
  def start_at=(new_start_at)
    puts "EventSearchForm.new(event_search_form_params)でstart_atカラムの値を設定するときに呼び出される"
    # 文字列型オブジェクトをTimeWithZoneオブジェクトに変換してセット
    # (byebug) start_at → "2024-06-10T07:23:32" (文字列型オブジェクト)
    # (byebug) @start_at → Mon, 10 Jun 2024 07:23:32.000000000 JST +09:00 (TimeWithZoneオブジェクト)
    @start_at = new_start_at.in_time_zone
  end

  private

  def keyword_for_search
    keyword.presence || '*'
  end
end
