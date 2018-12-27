require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    # 登録に失敗すると総ユーザ数が変わらないことを確認する
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
        email: "user@invalid.com",
        password: "foo", password_confirmation: "bar" }}
    end
    assert_template 'users/new'
    # エラーメッセージの表示確認
    assert_select 'div#error_explanation' do
      assert_select 'div.alert.alert-danger'
    end
  end

  test "valid signup information" do
    get signup_path
    assert_template 'users/new'
    assert_select 'form[action="/signup"]'
    # 登録に成功すると総ユーザ数が 1 変化することを確認する
    assert_difference 'User.count', 1 do
      post signup_path, params: { user: { name: "Exapmle User",
        email: "user@example.com",
        password: "P@ssw0rd", password_confirmation: "P@ssw0rd" }}
    end
    follow_redirect!
    assert_template 'users/show'
    # 成功時のflash messageの表示確認
    assert_not flash.empty?
    assert_select 'div.alert.alert-success'
  end


end
