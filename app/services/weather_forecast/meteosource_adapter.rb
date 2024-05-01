require 'net/http'
require 'json'
module WeatherForecast
  class MeteosourceAdapter < Adapter
    
    BASE_DAILY_URL = "https://ai-weather-by-meteosource.p.rapidapi.com/daily"
    
    def daily_forecast(lat, lng)
      response = make_api_call(lat,lng)
      if response.is_a?(Net::HTTPSuccess)
        body = JSON.parse(response.body)
        return extract_weather_details(body)
      elsif response.is_a?(Net::HTTPForbidden)
        raise "Invalid API key for Meteosource adapter"
      else
        raise "Failure response from Meteosource adapter - #{response.message}"
      end
    end
    
    private

    def make_api_call(lat,lng)
      query_params = { lat: lat, lon: lng, language: 'en', units: 'metric' }
      query_string = URI.encode_www_form(query_params)
      uri = URI(BASE_DAILY_URL + "?#{query_string}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Get.new(uri)
      request["X-RapidAPI-Key"] = ENV['METEOSOURCE_API_KEY']
      request["X-RapidAPI-Host"] = 'ai-weather-by-meteosource.p.rapidapi.com'
      return http.request(request)
    end

    def extract_weather_details(body)
      if body["daily"].nil? || body["daily"]["data"].nil?
        raise "Invalid response from Meteosource, missing daily data"
      end
      forecast_detail_struct_arr = []
      body["daily"]["data"].each do |data|
        forecast_detail_struct_arr << construct_forecast_detail_struct(data)
      end
      return forecast_detail_struct_arr
    end

    def construct_forecast_detail_struct(data)
      day = data["day"]
      weather_description = data["weather"]
      temperature = data["temperature"]
      temperature_min = data["temperature_min"]
      temperature_max = data["temperature_max"]
      summary = data["summary"]
      return FORECAST_DETAILS.new(
        day, weather_description, temperature, temperature_min, temperature_max, summary
      )
    end
  end
end

=begin
Sample response from meteo

{
  "lat": "19.0152N",
  "lon": "72.87472E",
  "elevation": 1,
  "units": "metric",
  "daily": {
    "data": [
      {
        "day": "2024-05-01",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Sunny, more clouds in the afternoon and evening. Temperature 28/33 °C. Wind from NW in the afternoon.",
        "predictability": 1,
        "temperature": 30,
        "temperature_min": 27.8,
        "temperature_max": 32.5,
        "feels_like": 32.2,
        "feels_like_min": 30.5,
        "feels_like_max": 34.2,
        "wind_chill": 32.8,
        "wind_chill_min": 30,
        "wind_chill_max": 36,
        "dew_point": 19.5,
        "dew_point_min": 17.5,
        "dew_point_max": 21.8,
        "wind": {
          "speed": 2.7,
          "gusts": 7.8,
          "dir": "WNW",
          "angle": 302
        },
        "cloud_cover": 21,
        "pressure": 1006,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 0,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 271.28,
        "humidity": 53,
        "visibility": 24.14
      },
      {
        "day": "2024-05-02",
        "weather": "sunny",
        "icon": 2,
        "summary": "Sunny. Temperature 26/32 °C.",
        "predictability": 3,
        "temperature": 28.8,
        "temperature_min": 26,
        "temperature_max": 31.8,
        "feels_like": 31.5,
        "feels_like_min": 29.8,
        "feels_like_max": 32.8,
        "wind_chill": 31,
        "wind_chill_min": 28,
        "wind_chill_max": 35,
        "dew_point": 18.5,
        "dew_point_min": 16.2,
        "dew_point_max": 21,
        "wind": {
          "speed": 2.4,
          "gusts": 6.8,
          "dir": "WNW",
          "angle": 292
        },
        "cloud_cover": 11,
        "pressure": 1006,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 0,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 277.07,
        "humidity": 54,
        "visibility": 24.13
      },
      {
        "day": "2024-05-03",
        "weather": "sunny",
        "icon": 2,
        "summary": "Sunny. Temperature 25/32 °C. Wind from NW in the afternoon.",
        "predictability": 3,
        "temperature": 28.8,
        "temperature_min": 25,
        "temperature_max": 32,
        "feels_like": 32,
        "feels_like_min": 29,
        "feels_like_max": 34,
        "wind_chill": 31,
        "wind_chill_min": 27,
        "wind_chill_max": 35,
        "dew_point": 19,
        "dew_point_min": 16.2,
        "dew_point_max": 22.2,
        "wind": {
          "speed": 2.4,
          "gusts": 7.6,
          "dir": "NW",
          "angle": 312
        },
        "cloud_cover": 13,
        "pressure": 1007,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 0,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 281.06,
        "humidity": 56,
        "visibility": 24.14
      },
      {
        "day": "2024-05-04",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Partly sunny. Temperature 26/32 °C. Wind from NW in the afternoon.",
        "predictability": 3,
        "temperature": 29.2,
        "temperature_min": 26,
        "temperature_max": 32,
        "feels_like": 32.8,
        "feels_like_min": 29,
        "feels_like_max": 34.8,
        "wind_chill": 31.8,
        "wind_chill_min": 28,
        "wind_chill_max": 35.8,
        "dew_point": 21.2,
        "dew_point_min": 19.5,
        "dew_point_max": 23.5,
        "wind": {
          "speed": 2.8,
          "gusts": 8.1,
          "dir": "NW",
          "angle": 316
        },
        "cloud_cover": 44,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 0,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 279.18,
        "humidity": 61,
        "visibility": 24.14
      },
      {
        "day": "2024-05-05",
        "weather": "sunny",
        "icon": 2,
        "summary": "Sunny. Temperature 27/34 °C. Wind from NW in the afternoon.",
        "predictability": 3,
        "temperature": 30.5,
        "temperature_min": 27.2,
        "temperature_max": 34.2,
        "feels_like": 34.2,
        "feels_like_min": 31.2,
        "feels_like_max": 36.2,
        "wind_chill": 33.2,
        "wind_chill_min": 29.2,
        "wind_chill_max": 37.8,
        "dew_point": 23,
        "dew_point_min": 21.8,
        "dew_point_max": 25,
        "wind": {
          "speed": 3.1,
          "gusts": 8.3,
          "dir": "NW",
          "angle": 311
        },
        "cloud_cover": 13,
        "pressure": 1006,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 0,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 280.4,
        "humidity": 65,
        "visibility": 24.13
      },
      {
        "day": "2024-05-06",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 28/32 °C.",
        "predictability": 3,
        "temperature": 29.5,
        "temperature_min": 28.2,
        "temperature_max": 31.5,
        "feels_like": 33.2,
        "feels_like_min": 31.5,
        "feels_like_max": 36,
        "wind_chill": 32,
        "wind_chill_min": 30.2,
        "wind_chill_max": 34.8,
        "dew_point": 22.8,
        "dew_point_min": 20.8,
        "dew_point_max": 24.8,
        "wind": {
          "speed": 3.1,
          "gusts": 7.2,
          "dir": "WNW",
          "angle": 291
        },
        "cloud_cover": 25,
        "pressure": 1007,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 0,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 282.68,
        "humidity": 67,
        "visibility": 24.14
      },
      {
        "day": "2024-05-07",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Sunny, more clouds in the afternoon and evening. Temperature 28/31 °C, but a feels-like temperature of up to 36 °C.",
        "predictability": 3,
        "temperature": 29,
        "temperature_min": 27.5,
        "temperature_max": 31,
        "feels_like": 33.2,
        "feels_like_min": 32.2,
        "feels_like_max": 36.2,
        "wind_chill": 31.2,
        "wind_chill_min": 29.5,
        "wind_chill_max": 33.5,
        "dew_point": 23.5,
        "dew_point_min": 22.5,
        "dew_point_max": 25.2,
        "wind": {
          "speed": 2.8,
          "gusts": 7.8,
          "dir": "WSW",
          "angle": 256
        },
        "cloud_cover": 22,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 1,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 284.98,
        "humidity": 71,
        "visibility": 24.13
      },
      {
        "day": "2024-05-08",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 27/31 °C. Wind from SW in the afternoon.",
        "predictability": 4,
        "temperature": 29,
        "temperature_min": 27,
        "temperature_max": 31.2,
        "feels_like": 34,
        "feels_like_min": 32.5,
        "feels_like_max": 35,
        "wind_chill": 30.8,
        "wind_chill_min": 29,
        "wind_chill_max": 34.2,
        "dew_point": 24,
        "dew_point_min": 21.5,
        "dew_point_max": 25,
        "wind": {
          "speed": 2.6,
          "gusts": 6.4,
          "dir": "WSW",
          "angle": 258
        },
        "cloud_cover": 26,
        "pressure": 1009,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 10,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 285.46,
        "humidity": 75,
        "visibility": 24.13
      },
      {
        "day": "2024-05-09",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 27/32 °C. Wind from NW in the afternoon.",
        "predictability": 4,
        "temperature": 29,
        "temperature_min": 27,
        "temperature_max": 31.5,
        "feels_like": 33.5,
        "feels_like_min": 32.5,
        "feels_like_max": 35,
        "wind_chill": 31.2,
        "wind_chill_min": 29,
        "wind_chill_max": 34,
        "dew_point": 22.8,
        "dew_point_min": 20.5,
        "dew_point_max": 24,
        "wind": {
          "speed": 3.2,
          "gusts": 6.6,
          "dir": "WNW",
          "angle": 284
        },
        "cloud_cover": 18,
        "pressure": 1007,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 11,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 283.48,
        "humidity": 69,
        "visibility": 24.1
      },
      {
        "day": "2024-05-10",
        "weather": "sunny",
        "icon": 2,
        "summary": "Sunny. Temperature 27/32 °C. Wind from NW in the afternoon.",
        "predictability": 4,
        "temperature": 29,
        "temperature_min": 27,
        "temperature_max": 31.5,
        "feels_like": 33.5,
        "feels_like_min": 32.5,
        "feels_like_max": 35,
        "wind_chill": 31.5,
        "wind_chill_min": 29.5,
        "wind_chill_max": 34,
        "dew_point": 22.8,
        "dew_point_min": 21,
        "dew_point_max": 24,
        "wind": {
          "speed": 3.2,
          "gusts": 6.5,
          "dir": "WNW",
          "angle": 286
        },
        "cloud_cover": 8,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 22,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 282.47,
        "humidity": 69,
        "visibility": 24.1
      },
      {
        "day": "2024-05-11",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 27/31 °C. Wind from NW in the afternoon.",
        "predictability": 4,
        "temperature": 29,
        "temperature_min": 27,
        "temperature_max": 31.2,
        "feels_like": 33.2,
        "feels_like_min": 32.5,
        "feels_like_max": 34.2,
        "wind_chill": 31.2,
        "wind_chill_min": 29,
        "wind_chill_max": 34.2,
        "dew_point": 23,
        "dew_point_min": 21.2,
        "dew_point_max": 24.2,
        "wind": {
          "speed": 3.3,
          "gusts": 6.5,
          "dir": "WNW",
          "angle": 299
        },
        "cloud_cover": 18,
        "pressure": 1009,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 13,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 282.02,
        "humidity": 70,
        "visibility": 24.1
      },
      {
        "day": "2024-05-12",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 27/32 °C. Wind from NW in the afternoon.",
        "predictability": 4,
        "temperature": 29,
        "temperature_min": 27,
        "temperature_max": 31.5,
        "feels_like": 33.5,
        "feels_like_min": 32.5,
        "feels_like_max": 35,
        "wind_chill": 31.5,
        "wind_chill_min": 29,
        "wind_chill_max": 34.5,
        "dew_point": 23.5,
        "dew_point_min": 21.8,
        "dew_point_max": 24.8,
        "wind": {
          "speed": 3.5,
          "gusts": 6.8,
          "dir": "WNW",
          "angle": 300
        },
        "cloud_cover": 12,
        "pressure": 1009,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 19,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 280.82,
        "humidity": 72,
        "visibility": 24.1
      },
      {
        "day": "2024-05-13",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Mostly cloudy changing to sunny by afternoon and evening. Temperature 27/32 °C. Wind from NW in the afternoon.",
        "predictability": 4,
        "temperature": 29.2,
        "temperature_min": 27.2,
        "temperature_max": 31.5,
        "feels_like": 34,
        "feels_like_min": 32.8,
        "feels_like_max": 35,
        "wind_chill": 31.8,
        "wind_chill_min": 29.2,
        "wind_chill_max": 34.5,
        "dew_point": 23.5,
        "dew_point_min": 22,
        "dew_point_max": 24.2,
        "wind": {
          "speed": 3.3,
          "gusts": 6.7,
          "dir": "WNW",
          "angle": 292
        },
        "cloud_cover": 31,
        "pressure": 1009,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 14,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 283.09,
        "humidity": 71,
        "visibility": 24.1
      },
      {
        "day": "2024-05-14",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 28/32 °C. Wind from NW in the afternoon.",
        "predictability": 4,
        "temperature": 29.2,
        "temperature_min": 27.5,
        "temperature_max": 31.5,
        "feels_like": 34,
        "feels_like_min": 33,
        "feels_like_max": 35,
        "wind_chill": 31.8,
        "wind_chill_min": 29.5,
        "wind_chill_max": 34.5,
        "dew_point": 23.2,
        "dew_point_min": 21.8,
        "dew_point_max": 24.8,
        "wind": {
          "speed": 3.4,
          "gusts": 6.6,
          "dir": "WNW",
          "angle": 283
        },
        "cloud_cover": 19,
        "pressure": 1009,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 18,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 282.53,
        "humidity": 71,
        "visibility": 24.1
      },
      {
        "day": "2024-05-15",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 27/31 °C. Wind from W in the afternoon.",
        "predictability": 4,
        "temperature": 29.2,
        "temperature_min": 27.2,
        "temperature_max": 31.2,
        "feels_like": 34.2,
        "feels_like_min": 33.2,
        "feels_like_max": 34.8,
        "wind_chill": 31.8,
        "wind_chill_min": 29.2,
        "wind_chill_max": 34.2,
        "dew_point": 23.5,
        "dew_point_min": 21.8,
        "dew_point_max": 24.8,
        "wind": {
          "speed": 3.1,
          "gusts": 6.4,
          "dir": "W",
          "angle": 280
        },
        "cloud_cover": 28,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 21,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 281.93,
        "humidity": 71,
        "visibility": 24.1
      },
      {
        "day": "2024-05-16",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon. Temperature 27/32 °C. Wind from W in the afternoon.",
        "predictability": 4,
        "temperature": 29.5,
        "temperature_min": 27.2,
        "temperature_max": 31.8,
        "feels_like": 34.2,
        "feels_like_min": 33.8,
        "feels_like_max": 35.8,
        "wind_chill": 31.8,
        "wind_chill_min": 29.2,
        "wind_chill_max": 34.8,
        "dew_point": 23.5,
        "dew_point_min": 22,
        "dew_point_max": 24.2,
        "wind": {
          "speed": 3.1,
          "gusts": 7.2,
          "dir": "W",
          "angle": 271
        },
        "cloud_cover": 19,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 57,
          "storm": 11,
          "freeze": 0
        },
        "ozone": 281.07,
        "humidity": 70,
        "visibility": 23.98
      },
      {
        "day": "2024-05-17",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Partly sunny, fewer clouds in the afternoon and evening. Temperature 28/31 °C.",
        "predictability": 4,
        "temperature": 29.2,
        "temperature_min": 27.5,
        "temperature_max": 31.2,
        "feels_like": 34.2,
        "feels_like_min": 33,
        "feels_like_max": 34.8,
        "wind_chill": 31.8,
        "wind_chill_min": 29.5,
        "wind_chill_max": 34.2,
        "dew_point": 23.8,
        "dew_point_min": 23.2,
        "dew_point_max": 24.5,
        "wind": {
          "speed": 3,
          "gusts": 5.7,
          "dir": "WSW",
          "angle": 250
        },
        "cloud_cover": 29,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 42,
          "storm": 0,
          "freeze": 0
        },
        "ozone": 282.58,
        "humidity": 72,
        "visibility": 24.08
      },
      {
        "day": "2024-05-18",
        "weather": "mostly_sunny",
        "icon": 3,
        "summary": "Partly sunny, fewer clouds in the afternoon. Temperature 28/32 °C.",
        "predictability": 4,
        "temperature": 29.5,
        "temperature_min": 27.5,
        "temperature_max": 31.5,
        "feels_like": 34.5,
        "feels_like_min": 34,
        "feels_like_max": 35.5,
        "wind_chill": 32,
        "wind_chill_min": 30,
        "wind_chill_max": 34.5,
        "dew_point": 24,
        "dew_point_min": 23,
        "dew_point_max": 24.8,
        "wind": {
          "speed": 3,
          "gusts": 6.6,
          "dir": "W",
          "angle": 267
        },
        "cloud_cover": 13,
        "pressure": 1008,
        "precipitation": {
          "total": 0.5,
          "type": "rain"
        },
        "probability": {
          "precipitation": 41,
          "storm": 24,
          "freeze": 0
        },
        "ozone": 284.86,
        "humidity": 73,
        "visibility": 23.9
      },
      {
        "day": "2024-05-19",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Partly sunny, fewer clouds in the evening. Temperature 28/31 °C.",
        "predictability": 4,
        "temperature": 29.5,
        "temperature_min": 27.8,
        "temperature_max": 31.2,
        "feels_like": 34.2,
        "feels_like_min": 33.8,
        "feels_like_max": 35.2,
        "wind_chill": 31.8,
        "wind_chill_min": 29.8,
        "wind_chill_max": 34.2,
        "dew_point": 24.2,
        "dew_point_min": 23,
        "dew_point_max": 25.2,
        "wind": {
          "speed": 2.8,
          "gusts": 5.9,
          "dir": "W",
          "angle": 268
        },
        "cloud_cover": 28,
        "pressure": 1008,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 38,
          "storm": 23,
          "freeze": 0
        },
        "ozone": 283.52,
        "humidity": 73,
        "visibility": 24.03
      },
      {
        "day": "2024-05-20",
        "weather": "sunny",
        "icon": 2,
        "summary": "Sunny. Temperature 28/32 °C.",
        "predictability": 4,
        "temperature": 29.5,
        "temperature_min": 27.8,
        "temperature_max": 31.5,
        "feels_like": 34.8,
        "feels_like_min": 33.8,
        "feels_like_max": 36,
        "wind_chill": 31.8,
        "wind_chill_min": 29.8,
        "wind_chill_max": 34,
        "dew_point": 23.8,
        "dew_point_min": 22.8,
        "dew_point_max": 24.8,
        "wind": {
          "speed": 2.7,
          "gusts": 6.3,
          "dir": "W",
          "angle": 278
        },
        "cloud_cover": 14,
        "pressure": 1008,
        "precipitation": {
          "total": 0.3,
          "type": "rain"
        },
        "probability": {
          "precipitation": 37,
          "storm": 12,
          "freeze": 0
        },
        "ozone": 281.41,
        "humidity": 71,
        "visibility": 24.05
      },
      {
        "day": "2024-05-21",
        "weather": "partly_sunny",
        "icon": 4,
        "summary": "Partly sunny. Temperature 28/32 °C.",
        "predictability": 4,
        "temperature": 29.5,
        "temperature_min": 27.5,
        "temperature_max": 31.5,
        "feels_like": 34.2,
        "feels_like_min": 33.2,
        "feels_like_max": 36,
        "wind_chill": 32,
        "wind_chill_min": 30,
        "wind_chill_max": 34,
        "dew_point": 23.5,
        "dew_point_min": 22.8,
        "dew_point_max": 24.5,
        "wind": {
          "speed": 2.6,
          "gusts": 7,
          "dir": "WNW",
          "angle": 286
        },
        "cloud_cover": 31,
        "pressure": 1009,
        "precipitation": {
          "total": 0,
          "type": "none"
        },
        "probability": {
          "precipitation": 47,
          "storm": 11,
          "freeze": 0
        },
        "ozone": 279.14,
        "humidity": 70,
        "visibility": 24.07
      }
    ]
  }
}
=end