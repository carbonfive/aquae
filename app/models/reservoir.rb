class Reservoir < ActiveRecord::Base

  LAT_LONG_REGEX = /\A-?\d+\.\d+\Z/

  validates :name, presence: true, uniqueness: true
  validates :code, presence: true, uniqueness: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :current_supply, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :latitude, presence: true, format: { with: LAT_LONG_REGEX }
  validates :longitude, presence: true, format: { with: LAT_LONG_REGEX }

  belongs_to :water_system

end
