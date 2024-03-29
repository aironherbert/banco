require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get login_path
    assert_response :success
  end

  test "should get create" do
    get signup_path
    assert_response :success
  end

  test "should get destroy" do
    get logout_path
    assert_response :redirect
  end
end
