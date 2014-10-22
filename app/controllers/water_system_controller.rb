class WaterSystemController < ApplicationController
  respond_to :json

  def show
    water_system = WaterSystem.find(params[:id])
    respond_with(water_system, include: :reservoirs, methods: [:current_supply_percentage, :health, :reservoir_names, :reservoir_chart_data])
  end
end
