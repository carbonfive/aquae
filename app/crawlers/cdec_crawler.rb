require 'nokogiri'
require 'open-uri'

class CDECCrawler

  attr_accessor :hydra

  def initialize(concurrency: 10)
    self.hydra = Typhoeus::Hydra.new(max_concurrency: concurrency)
  end

  def crawl_general_reservoir_data()
    index = Nokogiri::HTML(open('http://cdec.water.ca.gov/misc/resinfo.html'))

    index.css('.content_left_column table:first tr').each do |tr|
      next unless tr.at_css('td a').present? # skip the header row

      code = tr.at_css('td a').text.strip
      name = tr.at_css('td:nth(2)').text.strip
      capacity = tr.at_css('td:nth(5)').text.strip.gsub(',', '')

      puts "#{code} - #{name} - #{capacity}"

      if capacity && capacity.to_i > 0
        reservoir = Reservoir.find_or_initialize_by(code: code)
        reservoir.name = name
        reservoir.capacity = capacity
        reservoir.save!
      end
    end
  end

  def update_reservoir_details(reservoir)
    request = Typhoeus::Request.new("http://cdec.water.ca.gov/cgi-progs/stationInfo?station_id=#{reservoir.code}", followlocation: true)
    request.on_complete do |response|
      analyze_reservoir_details(reservoir, response.body)
    end
    hydra.queue request
  end

  def update_reservoir_monthly_averages(reservoir)
    request = Typhoeus::Request.new("http://cdec.water.ca.gov/cgi-progs/profile?s=#{reservoir.code}&type=res", followlocation: true)
    request.on_complete do |response|
      analyze_reservoir_monthly_averages(reservoir, response.body)
    end
    hydra.queue request
  end

  def update_reservoir_current_storage(reservoir)
    request = Typhoeus::Request.new("http://cdec.water.ca.gov/cgi-progs/queryDaily?s=#{reservoir.code}", followlocation: true) # daily
    request.on_complete do |response|
      if contains_current_storage_data(response.body)
        analyze_reservoir_current_storage(reservoir, response.body)
      else
        request = Typhoeus::Request.new("http://cdec.water.ca.gov/cgi-progs/queryMonthly?s=#{reservoir.code}", followlocation: true) # monthly
        request.on_complete do |response|
          analyze_reservoir_current_storage(reservoir, response.body)
        end
        hydra.queue request
      end
    end

    hydra.queue request
  end

  def contains_current_storage_data(body)
    doc = Nokogiri::HTML(body)
    return true if doc.css('table tr:first').text =~ /storage/i
    false
  end

  def analyze_reservoir_details(reservoir, body)
    doc = Nokogiri::HTML(body)

    begin
      longitude = doc.at_css('table:first tr:nth(4) td:nth(4)').text.strip[0..-3]
      latitude = doc.at_css('table:first tr:nth(4) td:nth(2)').text.strip[0..-3]
      puts "#{reservoir.code} - LON #{longitude} / LAT #{latitude}"
      reservoir.update!(lonlat: "POINT(#{longitude} #{latitude})")
    rescue
    end
  end

  def analyze_reservoir_monthly_averages(reservoir, body)
  end

  def analyze_reservoir_current_storage(reservoir, body)
    doc = Nokogiri::HTML(body)

    # check to see if there's any data for this reservoir_data.
    if doc.css('.content_left_column').text =~ /no daily data was found/i
      puts "#{reservoir.code} - No data availble."
      return
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
      puts "#{reservoir.code} - Error: Could not find data table."
      return
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
      puts "#{reservoir.code} - Error: Could not find 'storage' column."
      # puts %Q(#{reservoir_data[:code]} - #{doc.css(".content_left_column table:nth(#{table_index}) tr:first")})
      return
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
      return
    end

    puts "#{reservoir.code} - #{supply} / #{reservoir.capacity} - #{date_recorded}"

    reservoir.current_supply = supply
    reservoir.current_supply_captured_on = parse_dates(date_recorded, '%m/%d/%Y', '%m/%Y')
    reservoir.save!
  end

  def parse_dates(date, *formats)
    formats.each do |format|
      begin
        return Date.strptime(date, format)
      rescue ArgumentError
        next
      end
      nil
    end
  end

  def crawl
    # Fetch all reservoirs (code, name, total capacity) and create/update records for each one.
    crawl_general_reservoir_data

    # For each persisted reservoir, update lat/lon, historical averages, and current status.
    Reservoir.all.each do |reservoir|
      update_reservoir_details(reservoir)
      # update_reservoir_monthly_averages(reservoir)
      update_reservoir_current_storage(reservoir)
    end

    hydra.run

    # Log all errors.
  end
end