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
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # 渡されたユーザがログイン中アカウントのユーザと一致しているかを返す
  def current_user?(user)
    user == current_user
  end

  # ログイン済みかどうかを返す
  def logged_in?
    !current_user.nil?
  end

  # ユーザの永続的セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # ログアウトのためにセッションを削除する
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # GETでアクセスしようとしたURLを記憶しておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 記憶したURL(もしくはデフォルト値)にリダイレクトする
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end



end
