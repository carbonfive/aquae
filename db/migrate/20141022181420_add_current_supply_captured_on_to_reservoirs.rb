class AddCurrentSupplyCapturedOnToReservoirs < ActiveRecord::Migration
  def change
    add_column :reservoirs, :current_supply_captured_on, :date
  end
end
