class CreateHaodaifuHospitals < ActiveRecord::Migration
  def change
    create_table :haodaifu_hospitals do |t|
      t.string :name
      t.string :url
      t.string :h_area
      t.string :h_type
      t.string :h_grade
    end
  end
end
