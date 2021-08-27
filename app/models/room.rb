class Room < ApplicationRecord
  # ユーザー同士が会話をする部屋(room)

  # room内では多くのuser_roomがあるので、１対多
  has_many :user_rooms
  # room内では多くのchatがあるので、１対多
  has_many :chats

  def create_notification_chat(current_user, chat_id, room_id)
    # チャットしている相手を取得し、通知を送る
    temp_ids = Chat.select(:user_id).where(room_id: room_id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_chat(current_user, chat_id, temp_id['user_id'], room_id)
    end
    if temp_ids.blank?
      visited_id = UserRoom.where(room_id: room_id).where.not(user_id: current_user.id).distinct.first.user_id
      save_notification_chat(current_user, chat_id, visited_id, room_id)
    end
  end

  def save_notification_chat(current_user, chat_id, visited_id, room_id)
    # チャットは複数回することが考えられるため、複数回通知する
    notification = current_user.active_notifications.new(
      room_id: room_id,
      chat_id: chat_id,
      visited_id: visited_id,
      action: 'chat'
    )
    # 自分のチャットの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end
