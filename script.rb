require 'net/http'
require 'json'
require 'csv'

def get_weather(city, api_key)
  url = URI("http://api.openweathermap.org/data/2.5/weather?q=#{city}&appid=#{api_key}&units=metric")

  response = Net::HTTP.get(url)

  data = JSON.parse(response)

  {
    city: data['name'],
    temperature: data['main']['temp'],
    humidity: data['main']['humidity'],
    wind_speed: data['wind']['speed']
  }
end

def save_to_csv(weather_data)
  CSV.open("weather.csv", "w") do |csv|
    csv << ["City", "Temperature °C", "Humidity", "Wind speed"]

    csv << [weather_data[:city], weather_data[:temperature], weather_data[:humidity], weather_data[:wind_speed]]
  end
end

api_key = '29ca13bb04f671b0387769d9776a3d6d'

city = 'Kharkiv'

weather_data = get_weather(city, api_key)

save_to_csv(weather_data)

puts "Дані про погоду для міста #{city} збережено у файл weather.csv"
