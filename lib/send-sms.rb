require 'twilio-ruby'

account_sid = AUTH_DETAILS['TWILIO_ACCOUNT_SID']
auth_token = AUTH_DETAILS['TWILIO_AUTH_TOKEN']
client = Twilio::REST::Client.new(account_sid, auth_token)

from = AUTH_DETAILS['MY_TWILIO_PHONE_NUMBER'] # Your Twilio number
to = '' # Your mobile phone number

client.messages.create(
from: from,
to: to,
body: "Hey friend!"
)
