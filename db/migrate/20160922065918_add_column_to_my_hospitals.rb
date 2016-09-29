class AddColumnToMyHospitals < ActiveRecord::Migration
  def change
    add_column :my_hospitals, :amap_address, :string
    add_column :my_hospitals, :amap_location, :string
    add_column :my_hospitals, :amap_tel, :string
  end
end
