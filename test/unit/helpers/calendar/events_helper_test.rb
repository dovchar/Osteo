require 'test_helper'

module Calendar
  class EventsHelperTest < ActionView::TestCase
    test "datepair_tag" do
      event = Event.new
      event.title = 'date around midnight'
      Time.use_zone(Event::TIME_ZONE) do
        event.starts_at = Time.zone.local(2012, 02, 15, 23, 21)
        event.ends_at = event.starts_at + 1.hour
      end
      event.all_day = false

      html = datepair_tag(event.starts_at, event.ends_at, event.all_day)
      assert_equal 'Wed, February 15, 11:21pm &ndash; Thu, February 16, 12:21am', html
    end

    test "datepair_tag with another time zone" do
      old_zone = Event::TIME_ZONE
      Event::TIME_ZONE = 'Greenland'
      test_datepair_tag
      Event::TIME_ZONE = old_zone
    end
  end
end
