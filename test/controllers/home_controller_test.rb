require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get auth" do
    get home_auth_url
    assert_response :success
  end

end
