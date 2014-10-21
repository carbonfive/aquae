class CreateReservoirs < ActiveRecord::Migration
  def change
    create_table :reservoirs do |t|
      t.string :name
      t.string :code
      t.integer :capacity
      t.integer :current_supply
      t.string :latitude
      t.string :longitude

      t.timestamps null: false
    end
  end
end
