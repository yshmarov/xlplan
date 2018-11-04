require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post events_url, params: { event: { client_id: @event.client_id, client_price: @event.client_price, employee_id: @event.employee_id, employee_price: @event.employee_price, location_id: @event.location_id, service_description: @event.service_description, service_duration: @event.service_duration, service_id: @event.service_id, service_name: @event.service_name, start: @event.start, status: @event.status } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { client_id: @event.client_id, client_price: @event.client_price, employee_id: @event.employee_id, employee_price: @event.employee_price, location_id: @event.location_id, service_description: @event.service_description, service_duration: @event.service_duration, service_id: @event.service_id, service_name: @event.service_name, start: @event.start, status: @event.status } }
    assert_redirected_to event_url(@event)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
