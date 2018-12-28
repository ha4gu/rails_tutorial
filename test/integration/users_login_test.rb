require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    assert_select 'form[action="/login"]'
    post login_path, params: { session: { email: "invalid@example.com",
      password: "hogehoge" }}
    assert_template 'sessions/new'
    assert flash.any?
    # 画面遷移したらフラッシュメッセージが消えているかの確認
    get root_path
    assert flash.empty?
  end





end
