require 'test_helper'

class CashAccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @cash_account = cash_accounts(:one)
  end

  test "should get index" do
    get cash_accounts_url
    assert_response :success
  end

  test "should get new" do
    get new_cash_account_url
    assert_response :success
  end

  test "should create cash_account" do
    assert_difference('CashAccount.count') do
      post cash_accounts_url, params: { cash_account: { active: @cash_account.active, balance: @cash_account.balance, name: @cash_account.name } }
    end

    assert_redirected_to cash_account_url(CashAccount.last)
  end

  test "should show cash_account" do
    get cash_account_url(@cash_account)
    assert_response :success
  end

  test "should get edit" do
    get edit_cash_account_url(@cash_account)
    assert_response :success
  end

  test "should update cash_account" do
    patch cash_account_url(@cash_account), params: { cash_account: { active: @cash_account.active, balance: @cash_account.balance, name: @cash_account.name } }
    assert_redirected_to cash_account_url(@cash_account)
  end

  test "should destroy cash_account" do
    assert_difference('CashAccount.count', -1) do
      delete cash_account_url(@cash_account)
    end

    assert_redirected_to cash_accounts_url
  end
end
