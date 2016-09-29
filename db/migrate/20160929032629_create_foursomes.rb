class CreateFoursomes < ActiveRecord::Migration
  def change
    create_table :foursomes do |t|
      t.string :name

    end
  end
end
