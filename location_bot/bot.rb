require "sinatra/base"
# require 'rack'
# require 'twilio-ruby'

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
  lat={lat}&lon={lon}&appid={YOUR API KEY}
  BASE_URL = "https://api.openweathermap.org/data/2.5/onecall?"

  def forecast(lat, long)
    url_options = URI.encode_www_form({ :exclude => "minutely,daily,alerts,flags", :units => "si" })
    url = "#{BASE_URL}#{@api_key}/#{lat},#{long}?#{url_options}"
    url = "#{BASE_URL}lat=#{lat}&lon#{long}&appid=#{@api_key}"

    response = HTTP.get(url)
    result = JSON.parse(response.to_s)
  end
end