require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Quang Truong", email: "Qtruong0412@gmail.com")
  end
  test "shoud be valid" do
    assert @user.valid?
  end
  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end
  test "email should be present" do
    @User.email = " "
    assert_not @user.valid?
  end
end
