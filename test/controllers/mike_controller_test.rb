require 'test_helper'

class MikeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get mike_index_url
    assert_response :success
  end

end
