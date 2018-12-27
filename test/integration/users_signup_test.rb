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
    assert_select 'div#error_explanation' do
      assert_select 'div.alert.alert-danger'
    end
  end

end
