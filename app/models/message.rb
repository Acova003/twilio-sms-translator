require "faraday"
require "twilio-ruby"
class Message < ActiveRecord::Base



  def translate_and_send(phoneNumber, language, content)
    resp = Faraday.get 'https://translate.yandex.net/api/v1.5/tr.json/translate' do |req|
      req.params['lang'] = "en-#{language}"
      req.params['key'] = ENV['YANDEX_API_KEY']
      req.params['text'] = content
    end

    body = JSON.parse(resp.body)
    if resp.success?
      translated = body["text"][0]
      send(phoneNumber, translated)
    else
      raise ArgumentError, body
    end
  end

  def send(to, translated)
    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN'])

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to,
      body: translated
    )
  end
end
