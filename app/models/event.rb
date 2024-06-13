class Event < ApplicationRecord
  searchkick language: "japanese" # 検索用

  belongs_to :owner, class_name: "User" # イベントを作成したユーザの関連であることが分かりやすくなるようにownerという名前で設定
  
  has_many :tickets, dependent: :destroy

  has_one_attached :image, dependent: false # ActiveStorage::Attachmentオブジェクトのみを削除しActiveStorage::Blobオブジェクトは残しておく

  attr_accessor :remove_image

  before_save :remove_image_if_user_accept
  
  validates :name, length: { maximum: 50 }, presence: true
  validates :place, length: { maximum: 100 }, presence: true
  validates :content, length: { maximum: 2000 }, presence: true
  validates :start_at, presence: true
  validates :end_at, presence: true

  # gem 'active_storage_validations'によるバリデーション
  validates :image, 
    content_type: [:png, :jpg, :jpeg],
    size: { less_than_or_equal_to: 10.megabytes },
    dimension: { width: { max: 2000}, height: { max: 2000 }}

  validate :start_at_should_be_before_end_at

  def created_by?(user)
    return false unless user
    owner_id == user.id
  end

  private

  def start_at_should_be_before_end_at
    return unless start_at && end_at

    if start_at >= end_at
      errors.add(:start_at, "は終了時間よりも前に設定してください")
    end
  end

  def remove_image_if_user_accept
    # 画像を削除するにチェックが入っていればimageをnilにする
    self.image = nil if ActiveRecord::Type::Boolean.new.cast(remove_image)
  end
  
  # awesome_events/vendor/bundle/ruby/3.1.0/gems/searchkick-4.3.1/lib/searchkick/model.rbのsearch_dataを上書き
  # 検索キーワードに以下のカラムを指定
  # cf 設定時には、$ rails r Event.reindex を実行
  def search_data
    {
      name: name,
      place: place,
      content: content,
      owner_name: owner&.name,
      start_at: start_at
    }
  end
end
