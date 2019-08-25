require 'test_helper'

class BookingControllerTest < ActionDispatch::IntegrationTest
  test "should get list" do
    get booking_list_url
    assert_response :success
  end

  test "should get show" do
    get booking_show_url
    assert_response :success
  end

end
