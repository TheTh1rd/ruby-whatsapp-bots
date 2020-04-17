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
    
    if params["Latitude"] && params["Longitude"]
      #call weather API
      open_weather = OpenWeather.new(ENV['OPENWEATHER_TOKEN'])
      forecast = open_weather.forecast(params["Latitude"], params["Longitude"])
      puts forecast

      #parse API response to send to twilio
      forecast_message = "It is currently #{forecast["current"]["weather"][0]["description"]}  outside with a temperature of #{forecast["current"]["temp"].to_s}°F ."
      response.message body: forecast_message
    else
      #if no location is sent
      response.message body: "To get a weather forecast, send your location from WhatsApp."
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
  BASE_URL = "https://api.openweathermap.org/data/2.5/onecall?"

  #function to make api call
  def forecast(lat, long)
    url = "#{BASE_URL}lat=#{lat}&lon=#{long}&appid=#{@api_key}&units=imperial"
    puts url
    uri = URI(url)
    response = HTTP.get(uri)
    result = JSON.parse(response)
  end
end