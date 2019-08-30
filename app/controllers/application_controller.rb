require './config/environment'
#require js file
class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  get "/test" do
    erb :create_message
  end

  post "/message" do
    to = params[:phoneNumber]
    translated = TRANSLATED
    sms = SendMessage.new
    sms.send(to,translated)
  end
end
