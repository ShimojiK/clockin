SlackBot.setup do |config|
  config.token = ENV['SLACK_TOKEN_KEY']
  config.channel = ENV['SLACK_CHANNEL']
  config.bot_name = ENV['SLACK_BOT_NAME']
  config.body = 'no message'
end
