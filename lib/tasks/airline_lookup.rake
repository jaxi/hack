namespace :airline_lookup do

  desc "To import the airline lookup information"
  task import_airport: :environment do
    file = File.expand_path('open_data/airport_lookup.tsv', Rails.root)
    tsv = CSV.read(file, { :col_sep => "\t" })
    tsv.each do |row|
      Airport.create(
        airport_id: row[0],
        airport_name: row[1],
        city_id: row[2],
        city_name: row[3],
        country_id: row[4],
        country_name: row[5]
        )
    end
  end
end
