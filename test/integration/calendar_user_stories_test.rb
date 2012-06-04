require 'test_helper'

module Calendar
  class CalendarUserStoriesTest < ActionDispatch::IntegrationTest
    fixtures 'calendar/events'

    test "view calendar" do
      visit '/calendar'
      assert page.has_content?(Time.now.strftime("%B %Y"))

      visit "/calendar?date=#{calendar_events(:regular).starts_at}"
      assert page.has_content?('October 2010')
      assert page.has_content?('2a') # Translated from UTC to localtime by FullCalendar
      assert page.has_content?('Appointment')
    end

    test "create an event" do
      visit '/calendar'

      click_on 'Create'

      fill_in 'Title', with: 'My new event'
      fill_in 'Location', with: 'Paris'
      fill_in 'Description', with: 'This a new event'
      click_on 'Create event'

      # Check the flash
      assert page.has_content?("created.")

      # Back to the calendar, check the event was created
      assert page.has_content?('My new event')
    end

    test "try to create an invalid event" do
      visit '/calendar'

      click_on 'Create'

      fill_in 'Title', with: '' # An empty title is OK

      # Invalid dates: ends_at before starts_at
      fill_in 'event_starts_at_date', with: '2012-03-28'
      fill_in 'event_starts_at_time', with: '00:00'
      fill_in 'event_ends_at_date', with: '2012-03-27'
      fill_in 'event_ends_at_time', with: '00:00'

      fill_in 'Location', with: 'Paris'
      fill_in 'Description', with: 'This a new event'
      click_on 'Create event'

      # Failure
      assert page.has_content?("can't be before the starting date")
    end

    # Does not work under Mac
    # See http://stackoverflow.com/questions/7796495/capybara-drag-drop-does-not-work
    # See http://code.google.com/p/selenium/issues/detail?id=3363
    # Under other platforms try to downgrade Firefox
    # See http://stackoverflow.com/questions/9795868/org-openqa-selenium-invalidelementstateexceptioncannot-perform-native-interacti
    test "drag and drop an event" do
      visit "/calendar?date=#{calendar_events(:regular).starts_at}"

      # There is only 1 fc-event, the one that contains 'Appointment'
      source = find('.fc-event')

      # Select sunday inside the first week
      target = find('.fc-week0 .fc-sun')

      # Drag and drop the event to sunday 26th
      source.drag_to(target)

      if !(RUBY_PLATFORM =~ /darwin/)
        # Check the flash
        assert page.has_content?("updated.")
      end
    end

    test "try to drag and drop an invalid event" do
      visit "/calendar?date=#{calendar_events(:invalid).starts_at}"

      # There is only 1 fc-event, the one that contains the invalid event
      source = find('.fc-event')

      # Select sunday inside the fourth week
      target = find('.fc-week4 .fc-tue')

      # Drag and drop the event to tuesday 27th
      source.drag_to(target)

      if !(RUBY_PLATFORM =~ /darwin/)
        assert page.has_content?("Ends at can't be before the starting date")
      end
    end

    test "update an event" do
      visit "/calendar?date=#{calendar_events(:regular).starts_at}"

      # Click on the event
      find('.fc-event').click

      # Click on edit link inside the tooltip
      click_on 'Edit'

      fill_in 'Title', with: 'My updated event'
      fill_in 'Location', with: 'Paris'
      fill_in 'Description', with: 'This an updated event'
      click_on 'Update event'

      # Back to the calendar
      assert_equal calendar.root_path, current_path

      # Check the flash
      assert page.has_content?("updated.")

      # Check the event was updated
      visit "/calendar?date=#{calendar_events(:regular).starts_at}"
      assert page.has_content?('My updated event')
    end

    test "try to update an invalid event" do
      visit "/calendar?date=#{calendar_events(:regular).starts_at}"

      # Click on the event
      find('.fc-event').click

      # Click on edit link inside the tooltip
      click_on 'Edit'

      fill_in 'Title', with: '' # An empty title is OK

      # Invalid dates: ends_at before starts_at
      fill_in 'event_starts_at_date', with: '2012-03-28'
      fill_in 'event_starts_at_time', with: '00:00'
      fill_in 'event_ends_at_date', with: '2012-03-27'
      fill_in 'event_ends_at_time', with: '00:00'

      fill_in 'Location', with: 'Paris'
      fill_in 'Description', with: 'This an updated event'
      click_on 'Update event'

      # Failure
      assert page.has_content?("can't be before the starting date")
    end

    test "delete an event" do
      visit "/calendar?date=#{calendar_events(:regular).starts_at}"

      # Click on the event
      find('.fc-event').click

      # Click on destroy link inside the tooltip
      # See http://stackoverflow.com/questions/2458632/how-to-test-a-confirm-dialog-with-cucumber
      page.evaluate_script('window.confirm = function() { return true; }')
      click_on 'Delete'
      #page.driver.browser.switch_to.alert.accept

      # Check the flash
      assert page.has_content?("deleted.")

      # Close the flash
      find('.close').click

      assert page.has_no_content?('Appointment')
    end

    test "create an event by clicking on a day" do
      visit '/calendar'

      # Click on a day
      find(:xpath, "//td[starts-with(@class, 'fc-tue ui-widget-content fc-day9')]/div").click

      # Tooltip
      fill_in 'Title', with: 'New event using a tooltip'
      click_on 'Create event'

      # Check the flash
      assert page.has_content?("created.")

      # Check the event was created
      assert page.has_content?('New event using a tooltip')
    end

    test "edit an event by clicking on a day" do
      visit '/calendar?date="2012-04-01"'

      # Click on a day
      find(:xpath, "//td[starts-with(@class, 'fc-tue ui-widget-content fc-day9')]/div").click

      # Tooltip
      fill_in 'Title', with: 'Edit event using a tooltip'
      click_on 'edit_event'

      # Check the event inside the form
      assert_equal find_field('Title').value, 'Edit event using a tooltip'
      assert_equal '2012-04-10', find('#event_starts_at_date').value
      assert_equal '2012-04-10', find('#event_ends_at_date').value
      assert !find('#event_starts_at_time').visible?
      assert !find('#event_ends_at_time').visible?
      assert find('#event_all_day').checked?
    end

    test "all day event" do
      visit "/calendar?date=#{calendar_events(:all_day).starts_at}"

      # Click on the event
      find('.fc-event').click
      assert page.has_content?('All day event')
      assert page.has_content?('Thu, April 19')

      # Click on edit link inside the tooltip
      click_on 'Edit'

      assert find('#event_all_day').checked?
      assert !find('#event_starts_at_time').visible?
      assert !find('#event_ends_at_time').visible?

      uncheck 'All day'
      assert find('#event_starts_at_time').visible?
      assert find('#event_ends_at_time').visible?
    end
  end
end
