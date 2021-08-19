module NotificationsHelper

 def notification_form(notification)
    @visitor = notification.visitor
    @comment = nil
    @visiter_comment = notification.post_comment_id
    #notification.actionがfollowかlikeかcommentか
    case notification.action
    when "follow" then
      tag.a(notification.visitor.name, href: user_path(@visitor))+"さんがあなたをフォローしました"
    when "like" then
      tag.a(notification.visitor.name, href: user_path(@visitor))+"さんがあなたの"+tag.a('投稿', href: post_path(notification.post_id))+"にいいねしました"
    when "comment" then
      @comment = PostComment.find_by(id: @visitor_comment)&.content
      if @visitor == current_user
        tag.a(@visitor.name, href: user_path(@visitor))+"さんがあなたの"+tag.a('投稿', href: post_path(notification.post_id))+"にコメントしました"
      else
        tag.a(@visitor.name, href: user_path(@visitor))+"さんが"+()+"さんの"+tag.a('投稿', href: post_path(notification.post_id))+"にコメントしました"
      end
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end

end