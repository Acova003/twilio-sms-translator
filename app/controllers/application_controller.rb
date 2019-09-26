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
    # create an instance of a message, supplying the necessary data...
    my_message = Message.new(params[:phoneNumber], params[:language], params[:content])
    # and `send!` it! `send!` knows how to translate it and where to send it
    # because that's stored on the instance and is available to every method.
    my_message.send!
  end
end
