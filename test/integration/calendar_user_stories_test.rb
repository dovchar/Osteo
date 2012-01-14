require 'test_helper'

class CalendarUserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "view calendar" do
    visit '/calendar'
    assert page.has_content?(Time.now.strftime("%B %Y"))

    visit "/calendar?date=#{events(:alisson).starts_at}"
    assert page.has_content?('October 2010')
    assert page.has_content?('2a')  # Translated from UTC to localtime by FullCalendar
    assert page.has_content?('Appointment with Alisson')
  end

  test "create an event" do
    visit '/calendar'

    click_on 'Create'

    fill_in 'Title', with: 'My new event'
    fill_in 'Location', with: 'Paris'
    fill_in 'Description', with: 'This a new event'
    click_on 'Create Event'

    # Back to the calendar, check the event was created
    assert page.has_content?('My new event')
  end

  test "try to create an invalid event" do
    visit '/calendar'

    click_on 'Create'

    fill_in 'Title', with: ''
    fill_in 'Location', with: 'Paris'
    fill_in 'Description', with: 'This a new event'
    click_on 'Create Event'

    # Failure
    assert page.has_content?("Title can't be blank")
  end

  # FIXME Could not make drag and drop work under Capybara
  test "drag and drop an event" do
    visit "/calendar?date=#{events(:alisson).starts_at}"

    # There is only 1 fc-event, the one that contains 'Appointment with Alisson'
    source = page.find('.fc-event')

    # Select sunday inside the first week
    target = page.find('.fc-week0 .fc-sun')

    # Drag and drop the event to sunday 26th
    # FIXME This does not work
    source.drag_to(target)
  end

  test "update an event" do
    visit "/calendar?date=#{events(:alisson).starts_at}"

    # Click on the event
    page.find('.fc-event').click

    # Click on edit link inside the tooltip
    click_on 'Edit'

    fill_in 'Title', with: 'My updated event'
    fill_in 'Location', with: 'Paris'
    fill_in 'Description', with: 'This an updated event'
    click_on 'Update Event'

    # Back to the calendar, check the event was updated
    assert page.has_content?('My updated event')
  end

  test "try to update an event with invalid data" do
    visit "/calendar?date=#{events(:alisson).starts_at}"

    # Click on the event
    page.find('.fc-event').click

    # Click on edit link inside the tooltip
    click_on 'Edit'

    fill_in 'Title', with: ''
    fill_in 'Location', with: 'Paris'
    fill_in 'Description', with: 'This an updated event'
    click_on 'Update Event'

    # Failure
    assert page.has_content?("Title can't be blank")
  end

  test "destroy an event" do
    visit "/calendar?date=#{events(:alisson).starts_at}"

    # Click on the event
    page.find('.fc-event').click

    # Click on destroy link inside the tooltip
    # See http://stackoverflow.com/questions/2458632/how-to-test-a-confirm-dialog-with-cucumber
    page.evaluate_script('window.confirm = function() { return true; }')
    click_on 'Destroy'
    #page.driver.browser.switch_to.alert.accept

    # Back to the calendar, check the event was destroyed
    assert !page.has_content?('Appointment with Alisson')
  end
end
