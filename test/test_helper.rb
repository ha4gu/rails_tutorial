ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

# 単体テスト用
class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  include ApplicationHelper

  #include SessionsHelper
  # ↑これやるとcookieの取扱いで困る(signedが使えない)ことが分かった

  # テストユーザがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # テストユーザとしてログインする
  def log_in_as(user)
    session[:user_id] = user.id
  end

end

# 統合テスト用
class ActionDispatch::IntegrationTest

  # テストユーザとしてログインする
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
      password: password, remember_me: remember_me } }
  end

end
