# LocationBot WhatsApp bot

This bot is a whatsapp bot setup with Sinatra ready to receive incoming webhooks from Twilio and validate them, and a `config.ru` file to run the Sinatra app.

The bot responds to incoming messages with a weather forecast absed on the location recieved.

## Running the bot

Follow the instructions from the main [README](../README.md) to download the project, install the dependencies, set up the environment variables, and configure the WhatsApp sandbox.

From the root of the project you can run this bot with the command:

```bash
bundle exec rackup base/config.ru
```

Or within the `base` directory run:

```bash
bundle exec rackup
```