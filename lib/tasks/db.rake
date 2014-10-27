require './app/crawlers/cdec_crawler'

namespace :db do
  desc "Load a small, representative set of data so that the application can start in an use state (for development)."
  task sample_data: :environment do
    sample_data = File.join(Rails.root, 'db', 'sample_data.rb')
    load(sample_data) if sample_data
  end

  namespace :import do
    desc "Fetch a list of all reservoirs, then fetch additional data for each one (idempotent)."
    task reservoirs: :environment do
      CDECCrawler.new.crawl
    end
  end
end
