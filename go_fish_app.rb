require 'sinatra/base'
require 'slim'
require 'pry'
require_relative './go_fish_game'

class LoginScreen < Sinatra::Base
  enable :sessions

  get('/login') { slim :login }

  post('/login') do
    if params[:name].strip.empty?
      redirect '/login'
    else
      session['user_name'] = params[:name]
      game = GoFishGame.new(3)
      game.setup_game
      session['game_id'] = game.object_id
      GoFishApp.games[game.object_id] = game
      redirect '/'
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

  get '/' do
    
    @opponents = [{name: 'Gandalf', cards: 7, books: 0}, {name: 'Bob', cards: 7, books: 0}]

    @books = []

    2.times do
      @books << %w{a 2 3 4 5 6 7 8 9 10 j q k}.sample
    end
    
    slim :hand
  end

  post '/turn' do
    @result = @game.take_turn(params[:opponent].to_i, params[:card])
    @opponents = [{name: 'Gandalf', cards: 7, books: 0}, {name: 'Bob', cards: 7, books: 0}]

    @books = []

    2.times do
      @books << %w{a 2 3 4 5 6 7 8 9 10 j q k}.sample
    end
    
    slim :hand
  end
end