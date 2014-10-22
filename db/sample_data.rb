# Populate the database with a small set of realistic sample data so that as a developer/designer, you can use the
# application without having to create a bunch of stuff or pull down production data.
#
# After running db:sample_data, a developer/designer should be able to fire up the app, sign in, browse data and see
# examples of practically anything (interesting) that can happen in the system.
#
# It's a good idea to build this up along with the features; when you build a feature, make sure you can easily demo it
# after running db:sample_data.
#
# Data that is required by the application across all environments (i.e. reference data) should _not_ be included here.
# That belongs in seeds.rb instead.

def create_reservoir(code, name, capacity, current_supply, current_supply_captured_on, lon, lat)
  reservoir = Reservoir.find_or_initialize_by(code: code)
  reservoir.name = name
  reservoir.capacity = capacity
  reservoir.current_supply = current_supply
  reservoir.current_supply_captured_on = Date.parse(current_supply_captured_on) - 1.day
  reservoir.latlon = "POINT(#{lon} #{lat})"
  reservoir.save!
end

# East Bay

create_reservoir('PAR', 'Pardee', 297_950, 261_420, Date.current.to_s, '-120.85000', '38.250000')
create_reservoir('CMN', 'Camanche', 417_120, 132_820, Date.current.to_s, '-121.021000', '38.225000')
create_reservoir('BIO', 'Briones', 60_510, 40_800, Date.current.to_s, '-122.200000', '37.900000')
create_reservoir('CHB', 'Chabot', 10_350, 6_650, Date.current.to_s, '-122.122000', '37.730000')
create_reservoir('LFY', 'Lafayette', 4_250, 3_380, Date.current.to_s, '-122.138000', '37.885000')
create_reservoir('SPB', 'San Pablo', 38_600, 27_420, Date.current.to_s, '-122.333000', '37.958000')

WaterSystem.find_or_initialize_by(name: 'EBMUD').tap do |ws|
  ws.reservoirs << Reservoir.where(code: %w(PAR CMN BIO CHB LFY SPB))
end.save!

# San Francisco

create_reservoir('HTH', 'Hetch Hetchy', 360_000, 266_248, Date.current.to_s, '-119.783000', '37.950000')
create_reservoir('SNN', 'San Andreas Lake', 19_027, 17_256, Date.current.to_s, '-122.412000', '37.578000')
# No information found at http://cdec.water.ca.gov/misc/resinfo.html for Pilarcitos Lake.
create_reservoir('CRY', 'Crystal Springs', 57_910, 56_150, Date.current.to_s, '-122.360000', '37.530000')
create_reservoir('CVE', 'Calaveras', 100_000, 15_844, Date.current.to_s, '-121.818000', '37.492000')

WaterSystem.find_or_initialize_by(name: 'SFPUC').tap do |ws|
  ws.reservoirs << Reservoir.where(code: %w(HTH SNN CRY CVE))
end.save!

# Santa Monica - TBD
