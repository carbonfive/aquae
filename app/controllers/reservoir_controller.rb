class ReservoirController < ApplicationController
  respond_to :json

  def index
    factory = RGeo::GeoJSON::EntityFactory.instance
    features = Reservoir.where.not(lonlat: nil).includes(:water_system).map { |res|
      factory.feature res.lonlat,nil, { name: res.name,
                                        capacity: res.capacity,
                                        current_supply: res.current_supply,
                                        percentage_full: res.current_supply.present? ? Float(res.current_supply)/res.capacity : nil,
                                        water_system: res.water_system.try(:name),
                                      }
    }

    respond_with RGeo::GeoJSON.encode factory.feature_collection(features)
  end

end
