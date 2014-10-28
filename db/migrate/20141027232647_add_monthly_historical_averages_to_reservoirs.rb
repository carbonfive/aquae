class AddMonthlyHistoricalAveragesToReservoirs < ActiveRecord::Migration
  def change
    change_table :reservoirs do |t|
      t.integer :monthly_averages_start_year
      t.integer :monthly_averages_end_year
      t.integer :monthly_averages, array: true, default: [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
    end
  end
end
