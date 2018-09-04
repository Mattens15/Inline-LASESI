require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(username: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "username should be present" do
    @user.username="  "
    assert_not @user.valid?
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
    mixed_case_email = @user.email
    @user.email=@user.email.downcase
    @user.save
    assert_equal mixed_case_email, @user.email
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end