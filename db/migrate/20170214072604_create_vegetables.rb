class CreateVegetables < ActiveRecord::Migration
  def change
    create_table :vegetables do |t|
      t.string :name
      t.string :min_val
      t.string :ave_val
      t.string :max_val
      t.string :v_type
      t.string :unit
      t.string :send_date
    end
  end
end
