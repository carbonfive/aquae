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

# East Bay

Reservoir.find_or_create_by!(code: 'PAR') do |r|
  r.name = 'Pardee'
  r.capacity = 197_950
  r.current_supply = 161_420
  r.latlon = 'POINT(-120.85000 38.250000)'
end

Reservoir.find_or_create_by!(code: 'CMN') do |r|
  r.name = 'Camanche'
  r.capacity = 417_120
  r.current_supply = 132_820
  r.latlon = 'POINT(-121.021000 38.225000)'
end

Reservoir.find_or_create_by!(code: 'BIO') do |r|
  r.name = 'Briones'
  r.capacity = 60_510
  r.current_supply = 40_800
  r.latlon = 'POINT(-122.200000 37.900000)'
end

Reservoir.find_or_create_by!(code: 'CHB') do |r|
  r.name = 'Chabot'
  r.capacity = 10_350
  r.current_supply = 6_650
  r.latlon = 'POINT(-122.122000 37.730000)'
end

Reservoir.find_or_create_by!(code: 'LFY') do |r|
  r.name = 'Lafayette'
  r.capacity = 4_250
  r.current_supply = 3_380
  r.latlon = 'POINT(-122.138000 37.885000)'
end

Reservoir.find_or_create_by!(code: 'SPB') do |r|
  r.name = 'San Pablo'
  r.capacity = 38_600
  r.current_supply = 27_420
  r.latlon = 'POINT(-122.333000 37.958000)'
end

WaterSystem.find_or_create_by!(name: 'EBMUD').tap do |ws|
  ws.reservoirs << Reservoir.where(code: %w(PAR CMN BIO CHB LFY SPB))
end

# San Francisco

Reservoir.find_or_create_by!(code: 'HTH') do |r|
  r.name = 'Hetch Hetchy'
  r.capacity = 360_000
  r.current_supply = 266_248
  r.latlon = 'POINT(-119.783000 37.950000)'
end

Reservoir.find_or_create_by!(code: 'SNN') do |r|
  r.name = 'San Andreas Lake'
  r.capacity = 19_027
  r.current_supply = 17_256
  r.latlon = 'POINT(-122.412000 37.578000)'
end

# No information found at http://cdec.water.ca.gov/misc/resinfo.html
# Reservoir.find_or_create_by!(code: '') do |r|
#   r.name = 'Pilarcitos Lake'
#   r.capacity =
#   r.current_supply =
#   r.latlon = 'POINT()'
# end

Reservoir.find_or_create_by!(code: 'CRY') do |r|
  r.name = 'Crystal Springs'
  r.capacity = 57_910
  r.current_supply = 56_150
  r.latlon = 'POINT(-122.360000 37.530000)'
end

Reservoir.find_or_create_by!(code: 'CVE ') do |r|
  r.name = 'Calaveras'
  r.capacity = 100_000
  r.current_supply = 15_844
  r.latlon = 'POINT(-121.818000 37.492000)'
end

WaterSystem.find_or_create_by!(name: 'SFPUC').tap do |ws|
  ws.reservoirs << Reservoir.where(code: %w(HTH SNN CRY CVE))
end

# Santa Monica - TBD
