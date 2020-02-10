require 'json'
require 'open-uri'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    n = 0
    while n < 10
      @letters << alphabet.sample
      n += 1
    end
  end

  def word_exists(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    @found = JSON.parse(word_serialized)["found"]
  end

  def valid_word?(word, grid)
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def score
    session[:score] = 0 if session[:score].nil?
    @user_word = params[:word].upcase
    @grid = params[:letter_grid].split(" ")
    if valid_word?(@user_word, @grid)
      if word_exists(@user_word)
        @score = @user_word.length
        session[:score] += @score
        @message = "Congrats! #{@user_word} is a valid English word! You scored #{@score} points. Your total score is #{session[:score]}"
      else
        @message = "Sorry but #{@user_word} does not seem to be an English word ..."
      end
    else
      @message = "Sorry but #{@user_word} can't be built out of #{@grid}"
    end
  end
end
