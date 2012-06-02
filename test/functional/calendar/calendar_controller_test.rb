require 'test_helper'

module Calendar
  class CalendarControllerTest < ActionController::TestCase
    test "should get index" do
      get :index
      assert_response :success

      #assert_select_jquery :html, '#calendar' do
      #  assert_select '.fc-header', count: 1
      #  assert_select '.fc-content', count: 1
      #end
    end

    test "should get index and move to specified date" do
      get :index, { date: calendar_events(:regular).starts_at }
      assert_response :success

      #assert_select_jquery :html, '#calendar' do
      #  assert_select '.fc-header-title h2', 'October 2011'
      #  assert_select '.fc-event-time', '12a'
      #  assert_select '.fc-event-title', 'Appointment with Alisson'
      #end
    end

  end
end
