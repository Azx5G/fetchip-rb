require 'net/http'
require 'json'

def fetch_country_data
  url = URI('https://restcountries.com/v3.1/all')
  response = Net::HTTP.get(url)
  JSON.parse(response)
rescue => e
  puts "Failed to fetch country data: #{e.message}"
  []
end

def create_country_name_mapping
  country_data = fetch_country_data
  country_names = {}

  country_data.each do |country|
    english_name = country['name']['common']
    if country['name']['nativeName']
      native_name = country['name']['nativeName'].values.map { |n| n['common'] }.first
      country_names[english_name] = native_name
    else
      country_names[english_name] = english_name # Fallback to English name if native name is unavailable
    end
  end

  country_names
end

def get_country_name_in_native_language(english_name, country_names)
  country_names[english_name] || english_name
end

# Fetch country data and create mapping
country_names = create_country_name_mapping
