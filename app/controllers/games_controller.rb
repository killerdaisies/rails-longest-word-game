require 'open-uri'
require 'json'

class GamesController < ApplicationController
  LETTERS = ('a'..'z').to_a.sample(10)
  def new
  @letters = LETTERS.join(" ")
  end

  def score
    session[:total_score] = 0 if session[:total_score].nil?
    @letters = LETTERS
    @letters_string = @letters.join(" ")
    @word = params[:word]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    result = open(url).read
    test_word = JSON.parse(result)
    if @word.split('').all? { |e| @letters.include?(e) } != true
      @reply = "Sorry but #{@word} can't be built out of #{@letters_string}"
    elsif test_word["found"] != true
      @reply = "Sorry but #{@word} does not seem to be a valid English word..."
    else test_word["found"] = true
      @reply = "Congratulations! #{@word} is a valid English word!"
      session[:total_score] += @word.length
    end
    @total_score = session[:total_score]
  end
end
