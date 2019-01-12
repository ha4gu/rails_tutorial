require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @SAFETY_PASSWORD = "Vk3e6xudmoFSi3jL"
    @user = User.new(name: "Example User", email: "user@example.com",
                      password: @SAFETY_PASSWORD,
                      password_confirmation: @SAFETY_PASSWORD)
    @MAX_USER_LENGTH = 50
    @MAX_EMAIL_LENGTH = 255
    @MIN_PASSWORD_LENGTH = 6
  end

  test "should be valid" do
    assert @user.valid?
  end

  # tests for validation of presence

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  # tests for validation of length

  test "name should not be too long" do
    @user.name = "a" * (@MAX_USER_LENGTH + 1)
    assert_not @user.valid?
  end

  test "email should not be too long" do
    DOMAIN = "@example.com"
    @user.email = "a" * (@MAX_EMAIL_LENGTH - DOMAIN.length + 1) + DOMAIN
    assert_not @user.valid?
  end

  # tests for validation of format

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                            foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  # tests for validation of uniqueness

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = duplicate_user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # tests for letter case

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  # tests for validation of format

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * @MIN_PASSWORD_LENGTH
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * (@MIN_PASSWORD_LENGTH - 1)
    assert_not @user.valid?
  end

  # test for complicated cases

  test "authenticated? should return not execption but false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end
end
