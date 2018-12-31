module SessionsHelper

  # 引数で渡されたユーザのIDでセッションを生成する
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中アカウントのユーザを返す
  def current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

end
