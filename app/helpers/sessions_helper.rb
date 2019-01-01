module SessionsHelper

  # 引数で渡されたユーザのIDでセッションを生成する
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザの永続的セッションをセットする
  def remember(user)
    # トークンを生成し、ハッシュ値をDBに格納する
    user.remember
    # トークンを永続cookieに格納する
    cookies.permanent[:remember_token] = user.remember_token
    # ユーザIDを署名付き永続cookieに格納する
    cookies.permanent.signed[:user_id] = user.id
  end

  # ログイン中アカウントのユーザを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ログイン済みかどうかを返す
  def logged_in?
    !current_user.nil?
  end

  # ログアウトのためにセッションを削除する
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
