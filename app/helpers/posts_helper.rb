module PostsHelper

  def post_button
    if action_name == "new"
      "登録する"
    elsif action_name == "edit"
      "変更を保存"
    elsif action_name == "create"
      "登録する"
    else action_name == "update"
      "変更を保存"
    end
  end

end
