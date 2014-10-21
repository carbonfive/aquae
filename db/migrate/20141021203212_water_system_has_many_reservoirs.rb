class WaterSystemHasManyReservoirs < ActiveRecord::Migration
  def change
    add_reference :reservoirs, :water_system, index: true
  end
end
