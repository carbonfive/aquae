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
    ((current_supply.to_f / capacity.to_f) * 100.0).to_i
  end

  def health
    case current_supply_percentage
    when 0..20 then 'dire'
    when 21..40 then 'low'
    when 41..60 then 'normal'
    when 61..80 then 'good'
    when 81..100 then 'high'
    end
  end
end
