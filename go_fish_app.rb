require 'sinatra'
require 'slim'

opponents = [{name: 'Gandalf', cards: 3, books: 3},
            {name: 'Radagast', cards: 7, books: 2},
            {name: 'Galadriel', cards: 9, books: 1},
            {name: 'Elrond', cards: 1, books: 0},
            {name: 'Legolas', cards: 4, books: 1}]
player_name = 'Sauron'

get '/' do
  hand = []

  7.times do
    hand << %w{s c d h}.sample + %w{a 2 3 4 5 6 7 8 9 10 j q k}.sample
  end

  books = []

  2.times do
    books << %w{a 2 3 4 5 6 7 8 9 10 j q k}.sample
  end
  
  slim :hand, locals: {hand: hand, books: books, opponents: opponents, player_name: player_name}
end

post '/' do
  'You asked ' + params[:opponent] + ' for ' + params[:card]
end