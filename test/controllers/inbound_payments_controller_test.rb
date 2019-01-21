require 'test_helper'

class InboundPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @inbound_payment = inbound_payments(:one)
  end

  test "should get index" do
    get inbound_payments_url
    assert_response :success
  end

  test "should get new" do
    get new_inbound_payment_url
    assert_response :success
  end

  test "should create inbound_payment" do
    assert_difference('InboundPayment.count') do
      post inbound_payments_url, params: { inbound_payment: { amount: @inbound_payment.amount, client_id: @inbound_payment.client_id, event_id: @inbound_payment.event_id, payment_method: @inbound_payment.payment_method, tenant_id: @inbound_payment.tenant_id } }
    end

    assert_redirected_to inbound_payment_url(InboundPayment.last)
  end

  test "should show inbound_payment" do
    get inbound_payment_url(@inbound_payment)
    assert_response :success
  end

  test "should get edit" do
    get edit_inbound_payment_url(@inbound_payment)
    assert_response :success
  end

  test "should update inbound_payment" do
    patch inbound_payment_url(@inbound_payment), params: { inbound_payment: { amount: @inbound_payment.amount, client_id: @inbound_payment.client_id, event_id: @inbound_payment.event_id, payment_method: @inbound_payment.payment_method, tenant_id: @inbound_payment.tenant_id } }
    assert_redirected_to inbound_payment_url(@inbound_payment)
  end

  test "should destroy inbound_payment" do
    assert_difference('InboundPayment.count', -1) do
      delete inbound_payment_url(@inbound_payment)
    end

    assert_redirected_to inbound_payments_url
  end
end
