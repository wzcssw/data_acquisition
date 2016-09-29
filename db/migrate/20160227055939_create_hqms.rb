class CreateHqms < ActiveRecord::Migration
  def change
    create_table :hqms do |t|
      t.string :provinceId
      t.string :hName
      t.string :hGrade
      t.string :hType

      t.timestamps null: false
    end
  end
end
