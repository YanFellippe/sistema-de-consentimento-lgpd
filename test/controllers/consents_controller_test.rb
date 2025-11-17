require "test_helper"

class ConsentsControllerTest < ActionDispatch::IntegrationTest
  test "should get toggle" do
    get consents_toggle_url
    assert_response :success
  end
end
