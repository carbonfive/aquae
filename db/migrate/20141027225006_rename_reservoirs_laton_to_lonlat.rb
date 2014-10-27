class RenameReservoirsLatonToLonlat < ActiveRecord::Migration
  def change
    change_table :reservoirs do |t|
      t.rename :latlon, :lonlat
    end
  end
end
