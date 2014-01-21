require 'sinatra/base'
require 'slim'
require 'pry'
require 'pusher'
require_relative './go_fish_game'
require_relative './go_fish_game_status'

class LoginScreen < Sinatra::Base
  enable :sessions

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
    else
      session['user_name'] = params[:name]
      game = GoFishApp.open_game
      game.add_player(params[:name])
      GoFishApp.send_refresh(game.object_id)
      session['game_id'] = game.object_id
      redirect '/'
    end
  end
end

class GoFishApp < Sinatra::Base
  @@games = {}
  @@open_game = nil
  Pusher.url = "http://a10093afc889beb4f1a6:f295db5056072e839066@api.pusherapp.com/apps/63695"
  
  def self.reset
    @@games = {}
    @@open_game = nil
  end
  
  def self.games
    @@games
  end
  
  def self.open_game
    unless @@open_game
      @@open_game = GoFishGameStatus.new(2)
      @@games[open_game.object_id] = @@open_game
    end
    @@open_game
  end
  
  def self.create_game(hands = nil, deck = nil)
    @@open_game = GoFishGameStatus.new(2, hands, deck)
    @@games[open_game.object_id] = @@open_game
  end
  
  def self.send_refresh(game_id)
    Pusher[game_id.to_s].trigger('refresh', {
      message: 'refresh'
    })
  end
  
  # middleware will run before filters
  use LoginScreen

  before do
    unless session['user_name']
      redirect '/login'
    end
    @game = @@games[session['game_id']]
  end
  
  get '/' do
    redirect '/end' if @game.winner
    @result = @game.last_turn
    @player_number = @game.players.index(session['user_name']) + 1
    slim :hand
  end

  post '/turn' do
    @game.take_turn(params[:opponent].to_i, params[:card])
    GoFishApp.send_refresh(@game.object_id)
    redirect '/end' if @game.winner
    redirect '/'
  end
  
  get '/end' do
    slim :end_game
  end
end