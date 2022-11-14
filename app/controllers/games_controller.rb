require 'open-uri'
require 'json'
class GamesController < ApplicationController
  def new
    @letters = []
    counter = 0
    while counter <= 9
      @letters << ('a'..'z').to_a.sample
      counter += 1
    end
  end

  def score
    @guess = params[:word]
    @letters = params[:letters]
    @display = ''
    if included?(@guess.upcase, @letters.upcase)
      if english(@guess)
        @display = "Congratulations #{@guess} is a valid english guess"
      else
        @display = "Sorry but #{@guess} does not seem to be an english guess"
      end
    else
      @display = "Sorry but #{@guess} can't be built out of #{@letters}"
    end
  end

  private

  def english(guess)
    url = URI.open("https://wagon-dictionary.herokuapp.com/#{guess}")
    result = JSON.parse(url.read)
    result["found"]
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

end
