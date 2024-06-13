class CreateTickets < ActiveRecord::Migration[6.1]
  def change
    create_table :tickets do |t|
      t.references :user
      t.references :event, null: false, foreign_key: true
      t.string :comment

      t.timestamps
    end

    # 重複する中間モデルのオブジェクトの生成防止(ユーザが重複してイベントに参加表明すること防止)
    add_index :tickets, %i[event_id, user_id], unique: true
  end
end
