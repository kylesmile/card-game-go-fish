require 'sinatra/base'
require 'slim'
require 'pry'
require_relative './go_fish_game'

class LoginScreen < Sinatra::Base
  enable :sessions
  @@usernames = {}

  get '/login' do
    if session['user_name']
      redirect '/'
    else
      slim :login
    end
  end

  post '/login' do
    if params[:name].strip.empty?
      @login_message = "Please choose a valid username"
      slim :login
    elsif @@usernames[params[:name]]
      @login_message = "That username is in use"
      slim :login
    else
      session['user_name'] = params[:name]
      @@usernames[params[:name]] = session['session_id']
      game = GoFishGame.new(3)
      game.setup_game
      session['game_id'] = game.object_id
      GoFishApp.games[game.object_id] = game
      redirect '/games'
    end
  end
end

class GoFishApp < Sinatra::Base
  @@games = {}
  def self.games
    @@games
  end
  # middleware will run before filters
  use LoginScreen

  before do
    unless session['user_name']
      redirect '/login'
    end
    @game = @@games[session['game_id']]
  end

  get '/games' do
    slim :games
  end
  
  get '/' do #temporary
    @opponents = ['Gandalf', 'Bob']
    
    slim :hand
  end

  post '/turn' do
    @result = @game.take_turn(params[:opponent].to_i, params[:card])
    @opponents = ['Gandalf', 'Bob']
    
    slim :hand
  end
end