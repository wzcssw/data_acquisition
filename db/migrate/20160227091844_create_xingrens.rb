class CreateXingrens < ActiveRecord::Migration
  def change
    create_table :xingrens do |t|
      t.string :name
      t.string :title
      t.string :administrative
      t.string :area
      t.string :work_time
      t.string :head
      t.string :description

      t.timestamps null: false
    end
  end
end
