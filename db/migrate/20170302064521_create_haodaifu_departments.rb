class CreateHaodaifuDepartments < ActiveRecord::Migration
  def change
    create_table :haodaifu_departments do |t|
      t.string :name # 科室名
      t.string :url # 科室url
      t.string :category # 分类名称 比如 内科 外科  
      
      t.string :h_provice # 医院信息
      t.string :h_area
      t.string :h_name
      t.string :h_type  # 医院等级
    end
  end
end
