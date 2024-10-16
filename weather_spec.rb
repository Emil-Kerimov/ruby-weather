require 'rspec'
require './script.rb'

RSpec.describe 'Weather' do
  api_key = '29ca13bb04f671b0387769d9776a3d6d'
  city = 'Kharkiv'

  it 'повертає успішну відповідь з API' do
    response = get_weather(city, api_key)
    expect(response).not_to be_nil
    expect(response[:city]).to eq('Kharkiv')
  end

  it 'правильно обробляє дані з API' do
    weather_data = get_weather(city, api_key)

    expect(weather_data).to include(:city, :temperature, :humidity, :wind_speed)
    expect(weather_data[:city]).to eq('Kharkiv')

    expect(weather_data[:temperature]).to be_a(Numeric)
    expect(weather_data[:humidity]).to be_a(Numeric)
    expect(weather_data[:wind_speed]).to be_a(Numeric)
  end

  it 'зберігає дані у CSV файл' do
    weather_data = get_weather(city, api_key)
    save_to_csv(weather_data)

    expect(File.exist?('weather.csv')).to be true

    csv_content = CSV.read('weather.csv', headers: true)
    expect(csv_content.headers).to eq(["City", "Temperature °C", "Humidity", "Wind speed"])
    expect(csv_content[0]['City']).to eq('Kharkiv')
    expect(csv_content[0]['Temperature °C']).to be_a(String)
    expect(csv_content[0]['Humidity']).to be_a(String)
    expect(csv_content[0]['Wind speed']).to be_a(String)
  end
end