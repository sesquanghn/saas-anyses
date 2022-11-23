require 'slack-notifier'

class SlackNotifier < ApplicationService
  CHANNEL_HOOK_URL = {
    order: ENV['SLACK_ORDER_HOOK_URL'],
  }.freeze

  attr_reader :notifier, :message, :channel

  def initialize(chanel_hook, message, channel = '')
    @notifier = Slack::Notifier.new CHANNEL_HOOK_URL[chanel_hook]
    @message, @channel = message, channel
  end

  def execute
    ping_msg = channel.present? ? "<!#{channel}> #{message}" : message
    notifier.ping ping_msg
  rescue => e
    Rails.logger.error "Slack not working !"
    Rails.logger.error e.message
  end
end
