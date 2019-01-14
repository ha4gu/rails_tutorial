class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # use helpers of Session on whole controllers
  include SessionsHelper

  # temporary action for deploying to Heroku
  def hello
    render html: "hello world!"
  end

  private

  # ログイン済みかどうかを確認し、未ログインならログインページに飛ばす
  def logged_in_user
    unless logged_in?
      store_location # 元々アクセスしたかったURLをセッションに記憶する
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

end
