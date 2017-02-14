class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :project_body
      t.integer :report_type
      t.string :symptom
      t.text :expression
      t.string :diagnose
    end
  end
end