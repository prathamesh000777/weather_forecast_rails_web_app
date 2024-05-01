# weather_forecast_rails_web_app
Web application to get weather forecast by proving a address.

# Steps to start server

### 1. Database
A postgresql db named rails_weather_development

### 2. Memchached
Memcached server running on localhost:11211

### 3. Here API key
This is a third-party api that gives geo-cordinates details by accepting address. Documentation https://www.here.com/docs/bundle/geocoding-and-search-api-developer-guide/page/topics-api/code-geocode-address.html .
Add the api_key to environment variable, with key `HERE_API_KEY` 

### 4. AI Weather by Meteosource API key
This is third-party api used to fetch weather forecast details by latitude and longitude. Documentation https://rapidapi.com/MeteosourceWeather/api/ai-weather-by-meteosource/ .
Add the api_key to environment variable, with key `METEOSOURCE_API_KEY`


### Spin up the server
`rails s`
```
=> Booting Puma
=> Rails 5.2.8.1 application starting in development
=> Run `rails server -h` for more startup options
Puma starting in single mode...
* Version 3.12.6 (ruby 2.7.3-p183), codename: Llamas in Pajamas
* Min threads: 5, max threads: 5
* Environment: development
* Listening on tcp://localhost:3000
Use Ctrl-C to stop
```


# Homepage

![image](https://github.com/prathamesh000777/weather_forecast_rails_web_app/assets/51914475/c863ef35-1159-4f70-96b5-691887fff5ac)

# Forecast Result Page

### First time non-cached response

![image](https://github.com/prathamesh000777/weather_forecast_rails_web_app/assets/51914475/48698373-e6cf-48a8-8ffe-d5fce9ed71ad)


### Subsequent cached response

![image](https://github.com/prathamesh000777/weather_forecast_rails_web_app/assets/51914475/3bf5f8f9-ec83-4676-9565-e00ac0cb5049)



# Invalid Pincode Errors

![image](https://github.com/prathamesh000777/weather_forecast_rails_web_app/assets/51914475/041103a2-adb2-4aae-89a2-5f0dc8c57150)


# Here API Errors

![image](https://github.com/prathamesh000777/weather_forecast_rails_web_app/assets/51914475/00362589-6e20-4049-a296-5826796e01e5)


# Invalid Meteosource API Response Error

![image](https://github.com/prathamesh000777/weather_forecast_rails_web_app/assets/51914475/11b87cd9-7ed9-4197-a44a-641de9680a55)

