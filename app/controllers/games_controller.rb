class GamesController < ApplicationController
  def generate_grid(grid_size)
    letters = ("a".."z").to_a + ("a".."z").to_a
    random_grid = letters.sample(grid_size)
  end

  def new
    @letters = generate_grid(9)
    @start_time = Time.now
  end

  def word_attempt
    @end_time = Time.now
    @attempt = params[:word]
    test_word = @attempt.split('')
    test_word.each do |letter|
      if @letters.include? letter
        ur_attempt = true
        @letters.delete(letter)
      else
        ur_attempt = false
      end
      return ur_attempt
    end
  end

  score = 0
  
  def run_game
    timing = @end_time - @start_time
    search = @attempt
    word = JSON.parse(open("https://wagon-dictionary.herokuapp.com/#{search}").read)
    if word_attempt()
      if word['found']
        score = @attempt.length.fdiv(timing).round
        message = "well done"
      else
        score = 0
        message = "not an english word"
      end
    else
      score = 0
      message = "not in the grid"
    end
    result = { time: timing, score: score, message: message }
  end


  def score
    @result = run_game
  end
end