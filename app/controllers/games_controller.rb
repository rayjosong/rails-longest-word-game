class GamesController < ApplicationController

  def new
    @letters = generate_grid(10)
  end

  def score
    # check the word https://wagon-dictionary.herokuapp.com/:word
    @letters_set = params['collected_input'].chars.to_set.delete(" ")
    @word = params[:word].chars.to_set

    word_found = word_found?(params[:word])

    # The word can’t be built out of the original grid
    if !@word.subset?(@letters_set)
      separated_word = params[:word].chars.join(' ')
      @message = "Sorry but #{params['collected_input']} can't be built out of #{separated_word}"
    elsif word_found
      # The word is valid according to the grid and is an English word
      @message = "CONGRATULATIONS! #{params[:word]} is a according to grid and IS a valid english word"
    elsif !word_found
      # The word is valid according to the grid, but is not a valid English word
      @message = "#{params[:word]} is according to grid but not a valid english word"
    end
  end

  private

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    array = []
    # grid_size number of times
    until grid_size.zero?
      # generate random number according to number of letters
      rand_num = rand(('a'..'z').to_a.size)
      letter = ('a'..'z').to_a[rand_num].upcase
      array << letter
      grid_size -= 1
    end
    array
  end

  def word_found?(word)
    # initialise get request for API call
    url = "https://wagon-dictionary.herokuapp.com/#{params[:word]}"
    test_serialized = URI.open(url).read
    word_test = JSON.parse(test_serialized)
    found = word_test["found"]
  end

end
