require 'test_helper'

class TimeTest < ActionView::TestCase
  test "time should round" do
    time = Time.new(2011, 11, 13, 03, 50).round_time(10.minutes)
    assert_equal Time.new(2011, 11, 13, 03, 50), time

    time = Time.new(2011, 11, 13, 03, 51).round_time(10.minutes)
    assert_equal Time.new(2011, 11, 13, 03, 50), time

    time = Time.new(2011, 11, 13, 03, 59).round_time(10.minutes)
    assert_equal Time.new(2011, 11, 13, 04, 00), time

    time = Time.new(2011, 11, 13, 13, 42, 24).round_time()
    assert_equal Time.new(2011, 11, 13, 13, 42, 00), time

    time = Time.new(2011, 11, 13, 13, 42, 24).round_time(1.hour)
    assert_equal Time.new(2011, 11, 13, 14, 00, 00), time
  end

  test "time should format a datepair" do
    Time.use_zone(Event::TIME_ZONE) do
      current_year = Time.zone.now.year # 2012
      year_before = Time.zone.now.year - 1 # 2011

      # Entire day, this year (current_year)
      starts_at = Time.zone.local(current_year, 01, 31, 14, 30)
      str = Time.format_datepair(starts_at, nil, :all_day)
      assert_equal 'Tue, January 31', str

      starts_at = Time.zone.local(current_year, 01, 31, 14, 30)
      str = Time.format_datepair(starts_at, starts_at, :all_day)
      assert_equal 'Tue, January 31', str

      # Entire day, in year_before
      starts_at = Time.zone.local(year_before, 01, 31, 14, 30)
      str = Time.format_datepair(starts_at, nil, :all_day)
      assert_equal "Mon, January 31, #{year_before}", str

      # Same day, this year (current_year)
      starts_at = Time.zone.local(current_year, 01, 31, 14, 30)
      ends_at = Time.zone.local(current_year, 01, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal 'Tue, January 31, 2:30pm &ndash; 3pm', str

      starts_at = Time.zone.local(current_year, 01, 31, 14, 00)
      ends_at = Time.zone.local(current_year, 01, 31, 15, 30)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal 'Tue, January 31, 2pm &ndash; 3:30pm', str

      # Same day, in year_before
      starts_at = Time.zone.local(year_before, 01, 31, 14, 30)
      ends_at = Time.zone.local(year_before, 01, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal "Mon, January 31, #{year_before}, 2:30pm &ndash; 3pm", str

      starts_at = Time.zone.local(year_before, 01, 31, 14, 00)
      ends_at = Time.zone.local(year_before, 01, 31, 15, 30)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal "Mon, January 31, #{year_before}, 2pm &ndash; 3:30pm", str

      # Across days, this year (current_year)
      starts_at = Time.zone.local(current_year, 01, 31, 14, 30)
      ends_at = Time.zone.local(current_year, 10, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal 'Tue, January 31, 2:30pm &ndash; Wed, October 31, 3pm', str

      starts_at = Time.zone.local(current_year, 01, 31, 14, 00)
      ends_at = Time.zone.local(current_year, 10, 31, 15, 30)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal 'Tue, January 31, 2pm &ndash; Wed, October 31, 3:30pm', str

      # Across days, this year (current_year), entire days
      starts_at = Time.zone.local(current_year, 01, 31, 14, 30)
      ends_at = Time.zone.local(current_year, 10, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at, :all_day)
      assert_equal 'Tue, January 31 &ndash; Wed, October 31', str

      # Across days, in year_before
      starts_at = Time.zone.local(year_before, 01, 31, 14, 30)
      ends_at = Time.zone.local(year_before, 10, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal "Mon, January 31, #{year_before}, 2:30pm &ndash; Mon, October 31, 3pm", str

      starts_at = Time.zone.local(year_before, 01, 31, 14, 00)
      ends_at = Time.zone.local(year_before, 10, 31, 15, 30)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal "Mon, January 31, #{year_before}, 2pm &ndash; Mon, October 31, 3:30pm", str

      # Across days, in year_before, entire days
      starts_at = Time.zone.local(year_before, 01, 31, 14, 30)
      ends_at = Time.zone.local(year_before, 10, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at, :all_day)
      assert_equal "Mon, January 31, #{year_before} &ndash; Mon, October 31", str

      # Across years
      starts_at = Time.zone.local(year_before, 01, 31, 14, 30)
      ends_at = Time.zone.local(current_year, 10, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal "Mon, January 31, #{year_before}, 2:30pm &ndash; Wed, October 31, #{current_year}, 3pm", str

      starts_at = Time.zone.local(year_before, 01, 31, 14, 00)
      ends_at = Time.zone.local(current_year, 10, 31, 15, 30)
      str = Time.format_datepair(starts_at, ends_at)
      assert_equal "Mon, January 31, #{year_before}, 2pm &ndash; Wed, October 31, #{current_year}, 3:30pm", str

      # Across years, entire days
      starts_at = Time.zone.local(year_before, 01, 31, 14, 30)
      ends_at = Time.zone.local(current_year, 10, 31, 15, 00)
      str = Time.format_datepair(starts_at, ends_at, :all_day)
      assert_equal "Mon, January 31, #{year_before} &ndash; Wed, October 31, #{current_year}", str
    end
  end

  test "time should format a datepair with another time zone" do
    old_zone = Event::TIME_ZONE
    Event::TIME_ZONE = 'Greenland'
    test_time_should_format_a_datepair
    Event::TIME_ZONE = old_zone
  end
end
