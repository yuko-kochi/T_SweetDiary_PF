class NotificationsController < ApplicationController

  def index
    #current_userの投稿に紐づいた通知一覧
    @notifications = Notification.where(visited_id: current_user.id,checked: false ).where.not(visitor_id: current_user.id).page(params[:page]).per(10).to_a
    #@notificationの中でまだ確認していない(indexに一度も遷移していない)通知のみ
    @notifications.each do |notification|
      notification.update_attributes(checked: true)
    end
    @checked_notifications = Notification.where(visited_id: current_user.id, checked: true ).where.not(visitor_id: current_user.id)
  end

  def destroy
    notification = Notification.find(params[:id])
    notification.destroy
    redirect_to notifications_path
  end

  def destroy_all
    #通知を全削除
    @checked_notifications = Notification.where(visited_id: current_user.id, checked: true ).where.not(visitor_id: current_user.id)
    @checked_notifications.destroy_all
    redirect_to notifications_path
  end
  
end