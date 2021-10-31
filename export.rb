require 'smarter_csv'

data = 'oecd/DP_LIVE_31102021185423254.csv'
csv = CSV.read data, quote_char: "\x00", headers: true

data = []
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
  value = line[6]
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
data.each do |key, value|
  File.write "_data/#{key}.yml", value.to_yml
end
