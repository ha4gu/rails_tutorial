require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

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

  test "login with valid information, and then logout" do
    # login
    get login_path
    post login_path, params: { session: { email: @user.email,
      password: 'password' }}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    # logout
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    delete logout_path # 別窓でもログアウトするという特殊ケース
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count:0
  end

  test "login with remembering" do
    log_in_as(@user, remember_me: '1')
    assert_not_empty cookies['remember_token']
  end

  test "login without remembering" do
    # まず先にクッキーを保存してログインする
    log_in_as(@user, remember_me: '1')
    # ログアウトすることでクッキーを削除する
    delete logout_path
    # クッキーを保存せずにログインする
    log_in_as(@user, remember_me: '0')
    assert_empty cookies['remember_token']
  end

end
