require 'csv'
require 'yaml'

# Load
activities = YAML::load(File.open('_data/activities.yml'))
codes = YAML::load(File.open('_data/codes.yml'))
csv = CSV.read 'oecd/DP_LIVE_31102021185423254.csv',
                liberal_parsing: true,
                headers: true

# Parse
data = {}
locations = []
indicators = []
subjects = []
frequencies = []
measures = []
csv.each do |line|
  location = line[0]
  locations << location
  indicator = line[1]
  indicators << indicator
  subject = line[2]
  subjects << subject
  measure = line[3]
  measures << measure
  frequency = line[4]
  frequencies << frequency
  time = line[5]
  value = line[6].to_f
  flag = line[7]
  next if measure == 'AGRWTH'
  data[location] ||= {}
  data[location][time] ||= {}
  data[location][time][subject] = value
  # puts frequency
end
locations.uniq!
indicators.uniq!
subjects.uniq!
frequencies.uniq!
measures.uniq!
puts 'locations:'
puts locations
puts
puts 'indicators:'
puts indicators
puts
puts 'subjects:'
puts subjects
puts
puts 'frequencies:'
puts frequencies
puts
puts 'measures:'
puts measures

# Compute
countries = {}
years = {}
data.each do |country_key, country_data|
  country_data.each do |year, year_data|
    total = 0.0
    total_0 = 0.0
    year_data.each do |code, percent|
      indice = activities[code]['indice']
      total_0 += (1.0 - indice) * percent
      total += percent
    end
    indice = total_0 / total
    unless countries.has_key? country_key
      countries[country_key] = {
        'title' => codes[country_key]
      }
    end
    countries[country_key][year] = indice
    years[year] ||= {}
    years[year][country_key] = indice
  end
end

# Write

countries.each do |key, value|
  File.write "_countries/#{key.to_s}.yml", value.to_yaml
end

years.each do |key, value|
  File.write "_years/#{key.to_s}.yml", value.to_yaml
end
