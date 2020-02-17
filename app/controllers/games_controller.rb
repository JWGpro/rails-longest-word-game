require 'open-uri'

def word_in_grid?(word, grid)
  hash = Hash.new(0)
  grid.chars.each { |char| hash[char] += 1 }

  word.chars.each do |char|
    hash[char.upcase] -= 1
    return false if hash[char.upcase].negative?
  end

  true
end

def valid_word?(word)
  url = "https://wagon-dictionary.herokuapp.com/#{word}"
  json = JSON.parse(open(url).read)
  json['found']
end

class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
    session[:good_words] = session[:good_words] || []
  end

  def score
    in_grid = word_in_grid?(params[:attempt], params[:letters])
    valid = valid_word?(params[:attempt])

    if in_grid && valid
      session[:good_words] << params[:attempt]
      @result = "yes good, your words: #{session[:good_words]}"
    elsif in_grid
      @result = "#{params[:attempt]} is in grid but not valid"
    else
      @result = "can't build #{params[:attempt]} out of #{params[:letters]}"
    end
  end
end
