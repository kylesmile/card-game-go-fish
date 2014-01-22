require 'sinatra/base'
require 'slim'
require 'pry'
require 'pusher'
require_relative './go_fish_game_broker'

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
      game_id = GoFishApp.game_broker.associate_player(params[:name])
      GoFishApp.send_refresh(game_id)
      redirect "/games/#{game_id}"
    end
  end
end

class GoFishApp < Sinatra::Base
  @@game_broker = ::GoFishGameBroker.new
  Pusher.url = "http://a10093afc889beb4f1a6:f295db5056072e839066@api.pusherapp.com/apps/63695"
  
  def self.game_broker
    @@game_broker
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
  end
  
  get '/' do
    redirect '/login'
  end
  
  get '/games/:id' do |game_id|
    @game = @@game_broker.game(game_id)
    redirect "/games/#{game_id}/end" if @game.winner
    @result = @game.last_turn
    @player_number = @game.players.index(session['user_name']) + 1
    slim :hand
  end

  post '/games/:id/turn' do |game_id|
    @game = @@game_broker.game(game_id)
    @game.take_turn(params[:opponent].to_i, params[:card])
    GoFishApp.send_refresh(game_id)
    redirect "/games/#{game_id}/end" if @game.winner
    redirect "/games/#{game_id}"
  end
  
  get '/games/:id/end' do |game_id|
    @game = @@game_broker.game(game_id)
    slim :end_game
  end
end