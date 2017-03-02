class CreateHaodaifuProvinces < ActiveRecord::Migration
  def change
    create_table :haodaifu_provinces do |t|
      t.string :name
      t.string :url
    end
  end
end
