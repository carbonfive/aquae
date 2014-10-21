class WaterSystem < ActiveRecord::Base

  has_many :reservoirs

  validates :name, presence: true

end
