require "application_system_test_case"

class CashoutsTest < ApplicationSystemTestCase
  setup do
    @cashout = cashouts(:one)
  end

  test "visiting the index" do
    visit cashouts_url
    assert_selector "h1", text: "Cashouts"
  end

  test "creating a Cashout" do
    visit cashouts_url
    click_on "New Cashout"

    fill_in "Amount", with: @cashout.amount
    fill_in "Location", with: @cashout.location_id
    fill_in "Member", with: @cashout.member_id
    click_on "Create Cashout"

    assert_text "Cashout was successfully created"
    click_on "Back"
  end

  test "updating a Cashout" do
    visit cashouts_url
    click_on "Edit", match: :first

    fill_in "Amount", with: @cashout.amount
    fill_in "Location", with: @cashout.location_id
    fill_in "Member", with: @cashout.member_id
    click_on "Update Cashout"

    assert_text "Cashout was successfully updated"
    click_on "Back"
  end

  test "destroying a Cashout" do
    visit cashouts_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Cashout was successfully destroyed"
  end
end
