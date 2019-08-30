require 'twilio-ruby'
#require './javascipts/translate.js'

class SendSMS
  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end

  def send(to, translated)
    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
        to: to,
        body: translated
      )
    end
  end
