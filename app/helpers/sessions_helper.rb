module SessionsHelper

  # 引数で渡されたユーザのIDでセッションを生成する
  def log_in(user)
    session[:user_id] = user.id
  end


end
