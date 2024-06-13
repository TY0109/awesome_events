class Ticket < ApplicationRecord
  belongs_to :user, optional: :true # userが削除されても中間モデルのオブジェクトは残る
  belongs_to :event

  validates :comment, length: { maximum: 30 }, allow_blank: true
end
