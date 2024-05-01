class WeatherForecastController < ApplicationController
  before_action :initialize_address_details, only: [:forecast_by_address]
  before_action :validate_pincode, only: [:forecast_by_address]
  def forecast_by_address
    if @address_details.nil?
      render "address_input"
    else
      begin
        @cached_response = true
        @forecast_details = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
          @cached_response = false
          ::WeatherForecast::MeteosourceAdapter.new.daily_forecast(
            @address_details.lat, @address_details.lng
          )
        end
      rescue StandardError => e
        @error = e.message
        render "forecast_internal_error"
      end
    end
  end

  private

  def initialize_address_details
    return if params[:address].blank?
    @address_details = ::Geolocation::HereAdapter.new.details_from_address(params[:address])
  rescue StandardError => e
    @error = e.message
    render "forecast_internal_error"
  end

  def validate_pincode
    return if @address_details.nil? || @address_details.postal_code.present?
    render "pincode_error", status: :bad_request
  end

  def cache_key
    "forecast_details_#{@address_details.postal_code}"
  end
end
