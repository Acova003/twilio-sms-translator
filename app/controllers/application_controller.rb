require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome
  end

  get "/message" do
    erb :create_message
  end

  post "/message" do
    my_message = Message.new
    my_message.translate_and_send(params[:phoneNumber], params[:language], params[:content])
    erb :create_message
  end
end
