class ChatsController < ApplicationController
  before_action :follow_each_other, only: [:show]

  def show
    @user = User.find(params[:id])
    # カレントユーザーのuser_roomにあるroom_idの値の配列で取得しroomsに代入
    rooms = current_user.user_rooms.pluck(:room_id)
    # user_roomモデルからuser_idがチャット相手のidが一致するものと、
    # room_idが上記roomsのどれかに一致するレコードをuser_roomsに代入。
    # 共通のroom_idが存在していれば、その共通のroom_idとuser_idがuser_room変数に格納される（1レコード）
    # 存在しなければ、nilになる
    user_rooms = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    # もしuser_roomが空でないなら
    unless user_rooms.nil?
      # @roomに上記user_roomuser_roomに紐づくroomを代入
      @room = user_rooms.room
    else
      # それ以外は新しくroomを作る
      @room = Room.new
      @room.save
      # 採番したroomのidを使って、user_roomのレコードをカレントユーザー分とチャット相手分を作る
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
    end
    # @roomに紐づくchatsテーブルのレコードを@chatsに代入
    @chats = @room.chats
    # ここでroom.idを@chatに代入しておかないと、form_withで記述するroom_idに値が渡らない
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    if @chat.save
      room_user = @chat.room.user_rooms.all
      room_user.each do |user|
        @chat.room.create_notification_chat(current_user,@chat.id, @chat.room_id, user.user_id)
      end
      @chat = current_user.chats.new(chat_params)
    end
  end

  private
  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def follow_each_other
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      redirect_to user_path(user)
    end
  end

end