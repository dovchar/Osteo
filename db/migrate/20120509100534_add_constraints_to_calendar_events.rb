class AddConstraintsToCalendarEvents < ActiveRecord::Migration
  # See http://www.mikeperham.com/2012/05/05/five-common-rails-mistakes/
  # See http://stackoverflow.com/questions/5682068/rails-migration-remove-constraint
  def change
    change_column :calendar_events, :starts_at, :datetime, null: false
    change_column :calendar_events, :ends_at, :datetime, null: false
    change_column :calendar_events, :all_day, :boolean, null: false
  end
end
