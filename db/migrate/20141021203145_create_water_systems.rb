class CreateWaterSystems < ActiveRecord::Migration
  def change
    create_table :water_systems do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
