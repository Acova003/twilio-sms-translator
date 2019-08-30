require 'faraday'
require 'twilio-ruby'

class Message < ActiveRecord::Base
  def translate_and_send(phoneNumber, language, content)
    @key = 'trnsl.1.1.20190828T231112Z.8c3e93b59a2085dd.eab1c5d66b33f30d8cfead8081c9b5e2348b3ef3'
    @resp = Faraday.get 'https://translate.yandex.net/api/v1.5/tr.json/translate' do |req|
      req.params[‘lang’] = params[:language]
      req.params[‘key’] = @key
      req.params[‘text’] = params[:content]
    end

    body = JSON.parse(@resp.body)
    if @resp.success?
      @translated = body[“response”]
      send
    else
      @error = body[“meta”][“errorDetail”]
    end
  end

  def send(to, translated)
    to = params[:phoneNumber]
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN'])

    @client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: to,
      body: @translated
    )
  end
end
