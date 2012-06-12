require 'test_helper'

module Calendar
  class EventsControllerTest < ActionController::TestCase
    fixtures 'calendar/events'

    setup do
      @event = calendar_events(:regular)
      @invalid_event = calendar_events(:invalid)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:events)
    end

    test "should get index given start and end params" do
      # 1338069600 => 2012-05-26 22:00:00 UTC
      # 1341698400 => 2012-07-07 22:00:00 UTC
      get :index, { start: "1338069600", end: "1341698400" }

      assert_response :success

      events = assigns(:events)
      assert_equal 1, events.size
      assert_equal 'Very long', events[0].title
      assert_equal calendar_events(:very_long).starts_at, events[0].starts_at
      assert_equal Time.utc(2012, 05, 23, 00, 00), events[0].starts_at
      assert_equal calendar_events(:very_long).ends_at, events[0].ends_at
      assert_equal Time.utc(2012, 06, 10, 00, 00), events[0].ends_at
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create event" do
      assert_difference('Event.count') do
        post :create, event: @event.attributes
      end

      assert_redirected_to calendar.root_path
    end

    test "should not create invalid event" do
      assert_no_difference('Event.count') do
        post :create, event: @invalid_event.attributes
      end

      assert_template :new
    end

    test "should show event" do
      get :show, id: @event.to_param
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @event.to_param
      assert_response :success
    end

    test "should update event" do
      put :update, id: @event.to_param, event: @event.attributes
      assert_redirected_to calendar.root_path
    end

    test "should not update event with invalid data" do
      put :update, id: @invalid_event.to_param, event: @invalid_event.attributes
      assert_template :edit
    end

    test "should destroy event" do
      assert_difference('Event.count', -1) do
        delete :destroy, id: @event.to_param
      end

      assert_redirected_to calendar.root_path
    end
  end
end
