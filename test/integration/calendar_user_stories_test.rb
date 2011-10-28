require 'test_helper'

class CalendarUserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "view calendar" do
    visit '/calendar'
    assert page.has_content?(Time.now.strftime("%B %Y"))

    visit "/calendar?date=#{events(:alisson).starts_at}"
    assert page.has_content?('October 2010')
    assert page.has_content?('12a')
    assert page.has_content?('Appointment with Alisson')
  end

  test "create an event and show it inside calendar" do
    current_time = Time.now
    Event.create(
      title: 'An appointment',
      description: 'Regular 30 minutes medical consultation',
      starts_at: current_time,
      ends_at: current_time + (30 * 60),
      all_day: false
    )

    visit '/calendar'
    assert page.has_content?('An appointment')
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
end
