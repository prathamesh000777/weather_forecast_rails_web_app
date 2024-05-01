module WeatherForecast
  class Adapter
    FORECAST_DETAILS = Struct.new(:day, :weather_description, :temperature, :temperature_min, :temperature_max, :summary)
    def initialize
    end
  end
end
