class WaterSystemHasManyReservoirs < ActiveRecord::Migration
  def change
    add_reference :reservoirs, :water_system, index: true
    add_foreign_key :reservoirs, :water_systems
  end
end
