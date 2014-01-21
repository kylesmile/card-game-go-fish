require 'sinatra/base'
require 'slim'
require 'pry'
require 'pusher'
require_relative './go_fish_game'
require_relative './go_fish_game_status'

class LoginScreen < Sinatra::Base
  enable :sessions

  get '/login' do
    slim :login
  end

  post '/login' do
    if params[:name].strip.empty?
      @login_message = "Please choose a valid username"
      slim :login
    else
      session['user_name'] = params[:name]
      game = GoFishApp.open_game
      game.add_player(params[:name])
      GoFishApp.send_refresh(game.object_id.to_s)
      # session['game_id'] = game.object_id
      redirect "/games/#{game.object_id}"
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
    if @@open_game.nil? || @@open_game.open_slots == 0
      @@open_game = GoFishGameStatus.new(2)
      @@games[open_game.object_id.to_s] = @@open_game
    end
    @@open_game
  end
  
  def self.create_game(hands = nil, deck = nil)
    @@open_game = GoFishGameStatus.new(2, hands, deck)
    @@games[open_game.object_id.to_s] = @@open_game
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
    # @game = @@games[session['game_id']]
  end
  
  get '/' do
    redirect '/login'
  end
  
  get '/games/:id' do |game_id|
    @game = @@games[game_id]
    redirect "/games/#{game_id}/end" if @game.winner
    @result = @game.last_turn
    @player_number = @game.players.index(session['user_name']) + 1
    slim :hand
  end

  post '/games/:id/turn' do |game_id|
    @game = @@games[game_id]
    @game.take_turn(params[:opponent].to_i, params[:card])
    GoFishApp.send_refresh(@game.object_id)
    redirect "/games/#{game_id}/end" if @game.winner
    redirect "/games/#{game_id}"
  end
  
  get '/games/:id/end' do |game_id|
    @game = @@games[game_id]
    slim :end_game
  end
end