require "faraday"
require "twilio-ruby"

# Since we don't actually save our Message to
# the database, it doesn't need to be an
# ActiveRecord model (because AcctiveRecord
# provides all the database abstractions).
# It can be a plain Ruby object instead.
class Message
  # Every time we create a new Message instance,
  # we want it to remember what the message's
  # recipient, langauge, and content are, so that
  # we can refer to them later. Since
  # `to` is a preposition and `recipient` is a
  # noun, we'll use that varaible name.
  # And since `language` is ambiguous
  # (source language or target language?)
  # we'll specify that too.
  def initialize(recipient, target_language, content)
    # Here we use instance variables because we
    # want to keep track of a Message's language
    # and content across the entire instance,
    # including all it's methods.
    @recipient = recipient
    @target_language = target_language
    @content = content
  end

  # get_translation returns the translation for the
  # Message's content based on it's language.
  # Note that the Message's content isn't updated;
  # a whole new string is returned.

  def get_translation
    # Even though we're defining a whole new method,
    # we want it to have access to the same language
    # and content as when its instance was created
    # (so we again use the instance variables).
    resp = Faraday.get 'https://translate.yandex.net/api/v1.5/tr.json/translate' do |req|
      req.params['lang'] = "en-#{@target_language}" # this is easier to reason about w/ the new variable name
      req.params['key'] = ENV['YANDEX_API_KEY']
      req.params['text'] = @content
    end

    # The Ruby documentation for JSON.parse says:
    #
    # > parse(source, opts = {})
    # >
    # > Parse the JSON document `source` into a Ruby data structure
    # > and return it.
    #
    # Since it returns a Ruby data structure, and the input
    # data is a JSON document with a top-level JS hash,
    # the return data structure will be a Ruby hash.
    # Rember, `data.success?` is a method call (for a
    # method named `success?` on the hash `data`).
    # But no such method exists; in fact, if you look
    # at the response from a Yandex translate call,
    # it only has the properties `code`,
    # `lang`, and the `text` array. So it's successful
    # if the code is 200, and failed otherwise,
    # as per https://tech.yandex.com/translate/doc/dg/reference/translate-docpage/#codes
    data = JSON.parse(resp.body)
    if data['code'] == 200
      # We just want to return the text from the data.
      # We don't have to assign it to anything, or use
      # `return`, just make it the last expression.
      data["text"][0]
      # Note that we no longer call `send` here.
      # The purpose of this method, per it's name,
      # is to get the translation for the Message object
      # the method was called on.
    else
      # If it failed, whoever called this method
      # has to deal with it.
      raise RuntimeError, "Unexpcted Yandex code returned: #{data['code']}"
    end
  end

  # In this case, when we call `send`, we're telling it to
  # do a thing that has a side effect (in this case, send a translated
  # text message). Sometimes Rubyists name a method like this
  # with a bang, to make sure you know you're actually gonna do
  # something with this method instead of just return new data.
  def send!
    # But instead of passing `to` and `translated` as arguments
    # like we used to, we can just access data and methods on
    # the instance, thus removing duplication of data.
    translated = self.get_translation()

    client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN'])

    client.messages.create(
      from: ENV['TWILIO_PHONE_NUMBER'],
      to: @recipient, # the recipient is stored on the instance
      body: translated
    )
  end
end
