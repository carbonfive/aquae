class AddLatlonToReservoirs < ActiveRecord::Migration
  def change
    add_column :reservoirs, :latlon, :point, srid: 4326, geographic: true
    remove_column :reservoirs, :longitude, :string
    remove_column :reservoirs, :latitude, :string
  end
end
