class User < ApplicationRecord
  # owner_idを持つイベント(自分が作成したイベント)
  has_many :created_events, class_name: "Event", foreign_key: "owner_id", dependent: :nullify

  has_many :tickets, dependent: :nullify # userが削除されたらuser_idをnilに(user_idは必須でないためuser_idがnilであるticketが存在してもOK)

  # ticketオブジェクトを持つイベント(自分が参加表明したイベント)
  has_many :participating_events, through: :tickets, source: :event

  before_destroy :check_all_events_finished

  def self.find_or_create_from_auth_hash!(auth_hash)
    provider = auth_hash[:provider]
    uid = auth_hash[:uid]
    nickname = auth_hash[:info][:nickname]
    image_url = auth_hash[:info][:image]

    User.find_or_create_by!(provider: provider, uid: uid) do |user|
      user.name = nickname
      user.image_url = image_url
    end
  end

  private
  
    def check_all_events_finished
      now = Time.zone.now
      if created_events.where(":now < end_at", now: now).exists?
        errors[:base] << "あなたが作成した公開中のイベントが存在します"
        #<ActiveModel::Errors:0x0000000110825698 @base=#<User id: 2, provider: "github", uid: "99429343", name: "TY0109", image_url: "https://avatars.githubusercontent.com/u/99429343?v...", created_at: "2024-06-09 19:00:42.354493000 +0900", updated_at: "2024-06-09 19:00:42.354493000 +0900">, @errors=[#<ActiveModel::Error attribute=base, type=あなたが作成した公開中のイベントが存在します, options={}>]>
        # cf errors.add(:カラム名, "メッセージ")
      end
      
      if participating_events.where(":now < end_at", now: now).exists?
        errors[:base] << "未終了の参加イベントが存在します"
      end

      throw(:abort) unless errors.empty?
    end
end
