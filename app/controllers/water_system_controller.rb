class WaterSystemController < ApplicationController
  respond_to :json

  def show
    water_system = WaterSystem.find(params[:id])
    respond_with(water_system, methods: :current_supply_percentage)
  end
end
