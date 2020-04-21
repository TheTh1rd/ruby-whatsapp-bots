# LocationBot WhatsApp bot

This bot is a whatsapp bot setup with Sinatra ready to receive incoming webhooks from Twilio and validate them, and a `config.ru` file to run the Sinatra app.

The bot responds to incoming messages with a weather forecast based on the location recieved. As well as a few other easter eggs.

This project was started using this guide found at.
 https://www.twilio.com/blog/location-aware-whatsapp-bot-ruby-sinatra-twilio

## Running the bot

To set up the tunneling:

```bash
ngrok http 9292
```

From the root of the project you can run this bot with the command:

```bash
bundle exec rackup base/config.ru
```

Or within the `base` directory run:

```bash
bundle exec rackup
```