module Geolocation
  class Adapter
    ADDRESS_DETAILS = Struct.new(:country, :state, :city, :postal_code, :lat, :lng)
    def initialize
    end
  end
end
