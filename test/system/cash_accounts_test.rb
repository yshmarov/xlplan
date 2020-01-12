require "application_system_test_case"

class CashAccountsTest < ApplicationSystemTestCase
  setup do
    @cash_account = cash_accounts(:one)
  end

  test "visiting the index" do
    visit cash_accounts_url
    assert_selector "h1", text: "Cash Accounts"
  end

  test "creating a Cash account" do
    visit cash_accounts_url
    click_on "New Cash Account"

    check "Active" if @cash_account.active
    fill_in "Balance", with: @cash_account.balance
    fill_in "Name", with: @cash_account.name
    click_on "Create Cash account"

    assert_text "Cash account was successfully created"
    click_on "Back"
  end

  test "updating a Cash account" do
    visit cash_accounts_url
    click_on "Edit", match: :first

    check "Active" if @cash_account.active
    fill_in "Balance", with: @cash_account.balance
    fill_in "Name", with: @cash_account.name
    click_on "Update Cash account"

    assert_text "Cash account was successfully updated"
    click_on "Back"
  end

  test "destroying a Cash account" do
    visit cash_accounts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cash account was successfully destroyed"
  end
end
