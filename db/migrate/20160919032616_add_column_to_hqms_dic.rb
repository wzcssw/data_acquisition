class AddColumnToHqmsDic < ActiveRecord::Migration
  def change
    add_column :hqms, :hasdic, :boolean, :default => false
  end
end
