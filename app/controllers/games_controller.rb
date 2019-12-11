class GamesController < ApplicationController
  # 3 hours later ... don't put in GemFile ?!
  require 'open-uri'

  def generate_grid(grid_size)
    letters = ("a".."z").to_a + ("a".."o").to_a
    random_grid = letters.sample(grid_size)
  end

  def new
    @letters = generate_grid(9)
  end

  def included?(guess, grid)
    guess.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def my_word(attempt, grid)
    word = []
    test_word = attempt.each {|el| word.push(el.downcase) }
    word.each do |letter|
      if grid.include? letter
        @ur_attempt = true
        grid.delete(letter)
      else
        @ur_attempt = false
      end
    end
    return @ur_attempt
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def score
    word = params[:word]
    user_guess = params[:word].chars
    grid = params[:letters].chars
    if english_word?(word) && my_word(user_guess, grid)
      @score = "The word #{word.capitalize} is valid according to the grid and is an English word"
    elsif my_word(user_guess, grid)
      @score = "The word #{user_guess.join} is valid according to the grid, but is not a valid English word"
    else
      @score = "The word #{word.capitalize} can't be built out of the original grid"
    end
    return @score
  end
end