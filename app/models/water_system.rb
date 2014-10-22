class WaterSystem < ActiveRecord::Base
  has_many :reservoirs
  validates :name, presence: true

  def capacity
    reservoirs.sum(:capacity)
  end

  def current_supply
    reservoirs.sum(:current_supply)
  end

  def current_supply_percentage
    (current_supply.to_f / capacity.to_f) * 100.0
  end
end
