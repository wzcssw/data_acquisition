class CreateHaodaifuDoctors < ActiveRecord::Migration
  def change
    create_table :haodaifu_doctors do |t|
      t.string :doctor_name # 
      t.string :doctor_grade # 医生等级
      t.string :doctor_url # 医生等级

      t.string :department_name # 科室名
      t.string :department_category # 分类名称 比如 内科 外科  
      
      t.string :hospital_provice # 医院信息
      t.string :hospital_area
      t.string :hospital_name
    end
  end
end
