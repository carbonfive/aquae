require 'nokogiri'
require 'open-uri'

namespace :db do
  desc "Load a small, representative set of data so that the application can start in an use state (for development)."
  task sample_data: :environment do
    sample_data = File.join(Rails.root, 'db', 'sample_data.rb')
    load(sample_data) if sample_data
  end

  namespace :import do
    desc "Fetch a list of all reservoirs, then fetch additional data for each one (idempotent)."
    task reservoirs: :environment do

      index = Nokogiri::HTML(open('http://cdec.water.ca.gov/misc/resinfo.html'))

      reservoirs = []

      index.css('.content_left_column table:first tr').each do |tr|
        next unless tr.at_css('td a').present? # skip the header row

        code     = tr.at_css('td a').text.strip
        name     = tr.at_css('td:nth(2)').text.strip
        capacity = tr.at_css('td:nth(5)').text.strip.gsub(',', '')

        puts "#{code} - #{name} - #{capacity}"
        reservoirs << { code: code, name: name, capacity: capacity }
      end

      # reservoirs = [
      #   { code: 'SHA', name: 'Shasta', capacity: 500_000 },
      #   { code: 'PAR', name: 'Pardee', capacity: 500_000 },
      # ]

      puts '--------------------------------'

      reservoirs.each do |reservoir_data|
        next if Reservoir.where(code: reservoir_data[:code]).exists? && Reservoir.where(code: reservoir_data[:code], latlon: nil).empty?

        doc = Nokogiri::HTML(open("http://cdec.water.ca.gov/cgi-progs/stationInfo?station_id=#{reservoir_data[:code]}"))

        begin
          reservoir_data[:longitude] = doc.at_css('table:first tr:nth(4) td:nth(4)').text.strip[0..-3]
          reservoir_data[:latitude]  = doc.at_css('table:first tr:nth(4) td:nth(2)').text.strip[0..-3]
          puts "#{reservoir_data[:code]} - LON #{reservoir_data[:longitude]} / LAT #{reservoir_data[:latitude]}"
        rescue
        end
      end

      puts '--------------------------------'

      reservoirs.each do |reservoir_data|
        doc = Nokogiri::HTML(open("http://cdec.water.ca.gov/cgi-progs/queryDaily?s=#{reservoir_data[:code]}"))

        # check to see if there's any data for this reservoir_data.
        if doc.css('.content_left_column').text =~ /no daily data was found/i
          puts "#{reservoir_data[:code]} - No data availble."
          next
        end

        # find the data table, it's first row/column will have the text 'date'
        table_index = -1
        doc.css('.content_left_column table').each_with_index do |table, index|
          if table.css('tr:first td:first').text =~ /date/i
            table_index = index
            break
          end
        end

        if table_index < 0
          puts "#{reservoir_data[:code]} - Error: Could not find data table."
          next
        end

        table_index += 1

        # determine which column represents the storage column.
        storage_index = -1
        doc.css(".content_left_column table:nth(#{table_index}) tr:first td").each_with_index do |td, index|
          if td.text =~ /storage/i
            storage_index = index
            break
          end
        end

        if storage_index < 0
          puts "#{reservoir_data[:code]} - Error: Could not find 'storage' column."
          # puts %Q(#{reservoir_data[:code]} - #{doc.css(".content_left_column table:nth(#{table_index}) tr:first")})
          next
        end

        storage_index += 1

        # start from the bottom (latest), work our way up and look for a valid value.
        latest_data = nil
        doc.css(".content_left_column table:nth(#{table_index}) tr").reverse.each do |tr|
          node = tr.at_css("td:nth(#{storage_index})")

          if node.present? && node.text.strip.gsub(',', '') =~ /\d+/
            latest_data = tr
            break
          end
        end
        if latest_data.present?
          date_recorded = latest_data.at_css('td:first').text.strip
          supply = latest_data.at_css("td:nth(#{storage_index})").text.strip.gsub(',', '')
        else
          next
        end

        reservoir_data[:captured_on] = date_recorded
        reservoir_data[:current_supply] = supply

        puts "#{reservoir_data[:code]} - #{supply} / #{reservoir_data[:capacity]} - #{reservoir_data[:captured_on]}"

        r = Reservoir.find_or_initialize_by(code: reservoir_data[:code])
        r.name                       = reservoir_data[:name]
        r.latlon                     = "POINT(#{reservoir_data[:longitude]} #{reservoir_data[:latitude]})"
        r.capacity                   = reservoir_data[:capacity]
        r.current_supply             = reservoir_data[:current_supply].present? ? reservoir_data[:current_supply] : nil
        r.current_supply_captured_on = reservoir_data[:captured_on].present? ? Date.strptime(reservoir_data[:captured_on], '%m/%d/%Y') : nil
        r.save

        unless r.valid?
          puts "#{reservoir_data[:code]} - Error: #{r.errors.full_messages.join(', ')}"
        end
      end
    end
  end
end
