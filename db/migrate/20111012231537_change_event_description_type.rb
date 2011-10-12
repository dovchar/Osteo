class ChangeEventDescriptionType < ActiveRecord::Migration
  def up
    change_column :events, :description, :text, :limit => nil
  end

  def down
    change_column :events, :description, :string, :limit => 255
  end
end
