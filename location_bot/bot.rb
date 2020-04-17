require "sinatra/base"
# require 'rack'
# require 'twilio-ruby'

class LocationBot < Sinatra::Base
  # This will ensure that webhook requests definitely come from Twilio.
   use Rack::TwilioWebhookAuthentication, ENV['TWILIO_AUTH_TOKEN'], '/bot'

  # When we receive a POST request to the /bot endpoint this code will run.
  post '/bot' do

    # Initialise a new response object that we will build up.
    response = Twilio::TwiML::MessagingResponse.new

    if params["Latitude"] && params["Longitude"]
      open_weather = OpenWeather.new(ENV['OPENWEATHER_TOKEN'])
      forecast = open_weather.forecast(params["Latitude"], params["Longitude"])
      forecast_message = "It is currently"  #{forecast["current"]["weather"]["description"].downcase} with a temperature of #{forecast["current"]["temp"].to_s.split(".").first}°F."
      response.message body: forecast_message
    else
      response.message body: "To get a weather forecast, send your location from WhatsApp."
    end


    # Add a message to reply with
    response.message body: "Fuck you."
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
  def initialize(api_key)
    @api_key = api_key
  end
 
  BASE_URL = "https://api.openweathermap.org/data/2.5/onecall?"

  def forecast(lat, long)  
    url = "#{BASE_URL}lat=#{lat}&lon#{long}&appid=#{@api_key}&units=imperial"

    response = HTTP.get(url)
    result = JSON.parse(response.to_s)
  end
end