class Reservoir < ActiveRecord::Base

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :current_supply, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  set_rgeo_factory_for_column(:lonlat,
                              RGeo::Geographic.spherical_factory(:srid => 4326))

  belongs_to :water_system

end
