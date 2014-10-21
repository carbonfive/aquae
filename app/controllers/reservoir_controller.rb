class ReservoirController < ApplicationController
  respond_to :json

  def index
    factory = RGeo::GeoJSON::EntityFactory.instance
    features = Reservoir.all.map { |res|
      factory.feature res.latlon,nil, { desc: { name: res.name} }
    }

    respond_with RGeo::GeoJSON.encode factory.feature_collection(features)
  end

end