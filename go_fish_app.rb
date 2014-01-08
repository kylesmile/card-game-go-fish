require 'sinatra'
require 'slim'

hand = %w{sa ca da d2 h3 s7 cq hk}
books = %w{8 j 10}
opponents = [{name: 'Frodo B', cards: 3, books: 3},
           {name: 'Meriadoc B', cards: 7, books: 2},
           {name: 'Peregrin T', cards: 9, books: 1},
           {name: 'Samwise G', cards: 1, books: 0}]

get '/' do
  slim :hand, locals: {hand: hand, books: books, opponents: opponents}
end