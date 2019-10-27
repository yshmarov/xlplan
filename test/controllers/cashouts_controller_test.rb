require 'test_helper'

class CashoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cashout = cashouts(:one)
  end

  test "should get index" do
    get cashouts_url
    assert_response :success
  end

  test "should get new" do
    get new_cashout_url
    assert_response :success
  end

  test "should create cashout" do
    assert_difference('Cashout.count') do
      post cashouts_url, params: { cashout: { amount: @cashout.amount, location_id: @cashout.location_id, member_id: @cashout.member_id } }
    end

    assert_redirected_to cashout_url(Cashout.last)
  end

  test "should show cashout" do
    get cashout_url(@cashout)
    assert_response :success
  end

  test "should get edit" do
    get edit_cashout_url(@cashout)
    assert_response :success
  end

  test "should update cashout" do
    patch cashout_url(@cashout), params: { cashout: { amount: @cashout.amount, location_id: @cashout.location_id, member_id: @cashout.member_id } }
    assert_redirected_to cashout_url(@cashout)
  end

  test "should destroy cashout" do
    assert_difference('Cashout.count', -1) do
      delete cashout_url(@cashout)
    end

    assert_redirected_to cashouts_url
  end
end
