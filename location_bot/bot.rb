require "sinatra/base"
require 'net/http'
# require 'rack'
# require 'twilio-ruby'
STDOUT.sync = true
class LocationBot < Sinatra::Base
  # This will ensure that webhook requests definitely come from Twilio.
   use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  # When we receive a POST request to the /bot endpoint this code will run.
  post '/bot' do
    puts "Latitude: #{params["Latitude"]}"
    puts "Longitude: #{params["Longitude"]}"
    puts "Label: #{params["Label"]}"
    puts "Address: #{params["Address"]}"
    # Initialise a new response object that we will build up.
    response = Twilio::TwiML::MessagingResponse.new
    #send initial message
    response.message do |message|
      message.body("Welcome to weather buddy!")
      if params["Latitude"] && params["Longitude"]
        #call weather API
        open_weather = OpenWeather.new(ENV['OPENWEATHER_TOKEN'])
        forecast = open_weather.forecast(params["Latitude"], params["Longitude"])
        puts forecast
        weather_code = forecast["weather"][0]["id"]
        weather_icon = forecast["weather"][0]["icon"]

        
        case weather_code
        when /\A2/
          forecast_message = "Dont forget an umbrella, looks like your in for some thunderstorms."
        when /\A3/
          forecast_message  = "Bring an umbrella or coat, looks like its drizzling."
        when /\A5/
          forecast_message = "Dont forget an umbrella, looks like your in for some rain."
        when /\A6/
          forecast_message = "Time to grab some hat and gloves, its snowing out."
        when /\A7/ 
          forecast_message = "Is Mist really a weather forecast? I dont know what to say apple bought the good API."
        when "800"
          forecast_message = "Nice clear day in store for you!"
        else
          forecast_message = "Some clouds are in todays forecast, but hey, atleast its not raining. "
          icon_message = "http://openweathermap.org/img/wn/#{weather_icon}@2x.png"
        end

        #parse API response to send to twilio
        #oneapi call 
        temp_message = " The current temperature is #{forecast["main"]["temp"].round().to_s}°F ."
        message.body(forecast_message)
        message.media(icon_message)
        message.body(temp_message)
      else
        #if no location is sent
        #response.message body: "To get a weather forecast, send your location from WhatsApp."
      end
    end

  
    # TwiML is XML, so we set the Content-Type response header to text/xml
    content_type "text/xml"
    # Respond with the XML of the response object.
    response.to_xml
  end
  get '/' do
    "Hey, what you doing here?"
    "Go Home"
  end
end

class OpenWeather
  #setting api key from env.yml
  def initialize(api_key)
    @api_key = api_key
  end
  BASE_URL = "https://api.openweathermap.org/data/2.5/weather?"

  #function to make api call
  def forecast(lat, long)
    url = "#{BASE_URL}lat=#{lat}&lon=#{long}&appid=#{@api_key}&units=imperial"
    puts url
    uri = URI(url)
    response = HTTP.get(uri)
    result = JSON.parse(response)
  end
end