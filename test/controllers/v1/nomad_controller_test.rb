require 'test_helper'

class V1::NomadControllerTest < ActionDispatch::IntegrationTest
  test "should get stoped" do
    get v1_nomad_stoped_url
    assert_response :success
  end

  test "should get start" do
    get v1_nomad_start_url
    assert_response :success
  end

  test "should get timeout" do
    get v1_nomad_timeout_url
    assert_response :success
  end

  test "should get fail" do
    get v1_nomad_fail_url
    assert_response :success
  end

  test "should get success" do
    get v1_nomad_success_url
    assert_response :success
  end

  test "should get maintenance" do
    get v1_nomad_maintenance_url
    assert_response :success
  end

end
