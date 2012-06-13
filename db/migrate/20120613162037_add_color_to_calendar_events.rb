class AddColorToCalendarEvents < ActiveRecord::Migration
  def change
    add_column :calendar_events, :color, :string
  end
end
