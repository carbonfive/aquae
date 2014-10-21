class Reservoir < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :current_supply, presence: true, numericality: { greater_than_or_equal_to: 0 }

  belongs_to :water_system

  set_rgeo_factory_for_column(:latlon,
                              RGeo::Geographic.spherical_factory(:srid => 4326))

end
