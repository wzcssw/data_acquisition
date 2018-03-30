class CreateQccs < ActiveRecord::Migration
  def change
    create_table :qccs do |t|
      t.string :topic
      t.string :shareUrl
      t.string :shareholder_type
      t.string :parentid
      t.boolean :finished,default: false # 是否爬过
      t.string :old_names

      t.timestamps null: false
    end
  end
end
