require 'net/http'
require 'json'
module Geolocation
  class HereAdapter < Adapter
    
    BASE_URL = "https://geocode.search.hereapi.com/v1/geocode"

    def details_from_address(address)
      response = make_api_call(address)
      if response.is_a?(Net::HTTPSuccess)
        body = JSON.parse(response.body)
        return extract_address_details(body)
      elsif response.is_a?(Net::HTTPUnauthorized)
        raise "Invalid API key for Here adapter"
      else
        raise "Failure response from Here adapter - #{response.message}"
      end
    rescue StandardError => e
      Rails.logger.error "Error Processing GeolocationService: #{e.message}"
      raise "Error Processing GeolocationService - #{e.message}"
    end

    private 

    def make_api_call(address)
      query_params = { q: address, apiKey: ENV['HERE_API_KEY'] }
      query_string = URI.encode_www_form(query_params)
      uri = URI(BASE_URL + "?#{query_string}")
      return ::Net::HTTP.get_response(uri)
    end

    def extract_address_details(body)
      if body['items'].nil? || body['items'][0].nil? || body['items'][0]['position'].nil?
        return ADDRESS_DETAILS.new
      end
      location = body['items'][0]['position']
      lat = location['lat']
      lng = location['lng']
      address = body['items'][0]['address']
      country = address.try(:[],'countryName')
      state = address.try(:[],'state')
      city = address.try(:[],'city')
      postal_code = address.try(:[],'postalCode')
      return ADDRESS_DETAILS.new(country, state, city, postal_code, lat, lng)
    end
  end
end

=begin
Sample response from here
{
  "items": [
      {
          "title": "400037, Mumbai, Maharashtra, India",
          "id": "here:cm:namedplace:22807156",
          "resultType": "locality",
          "localityType": "postalCode",
          "address": {
              "label": "400037, Mumbai, Maharashtra, India",
              "countryCode": "IND",
              "countryName": "India",
              "stateCode": "MH",
              "state": "Maharashtra",
              "county": "Mumbai Suburban",
              "city": "Mumbai",
              "district": "Wadala East",
              "postalCode": "400037"
          },
          "position": {
              "lat": 19.0152,
              "lng": 72.87472
          },
          "mapView": {
              "west": 72.85493,
              "south": 18.99908,
              "east": 72.88572,
              "north": 19.04006
          },
          "scoring": {
              "queryScore": 0.99,
              "fieldScore": {
                  "district": 0.86,
                  "postalCode": 1
              }
          }
      }
  ]
}
=end