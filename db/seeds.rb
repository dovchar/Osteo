# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Event.delete_all

current_time = Time.now

Event.create(
  :title => 'Appointment with Alisson',
  :description => 'Regular 30 minutes medical consultation',
  :starts_at => current_time,
  :ends_at => current_time + (30 * 60),
  :all_day => false
)
