require "application_system_test_case"

class InboundPaymentsTest < ApplicationSystemTestCase
  setup do
    @inbound_payment = inbound_payments(:one)
  end

  test "visiting the index" do
    visit inbound_payments_url
    assert_selector "h1", text: "Inbound Payments"
  end

  test "creating a Inbound payment" do
    visit inbound_payments_url
    click_on "New Inbound Payment"

    fill_in "Amount", with: @inbound_payment.amount
    fill_in "Client", with: @inbound_payment.client_id
    fill_in "Event", with: @inbound_payment.event_id
    fill_in "Payment method", with: @inbound_payment.payment_method
    fill_in "Tenant", with: @inbound_payment.tenant_id
    click_on "Create Inbound payment"

    assert_text "Inbound payment was successfully created"
    click_on "Back"
  end

  test "updating a Inbound payment" do
    visit inbound_payments_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @inbound_payment.amount
    fill_in "Client", with: @inbound_payment.client_id
    fill_in "Event", with: @inbound_payment.event_id
    fill_in "Payment method", with: @inbound_payment.payment_method
    fill_in "Tenant", with: @inbound_payment.tenant_id
    click_on "Update Inbound payment"

    assert_text "Inbound payment was successfully updated"
    click_on "Back"
  end

  test "destroying a Inbound payment" do
    visit inbound_payments_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Inbound payment was successfully destroyed"
  end
end
