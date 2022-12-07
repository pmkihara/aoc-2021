# --- Day 4: Giant Squid ---

def boards(input)
  # Divides the input into arrays of boards and removes the empty space
  boards_as_array_of_strings = input.slice_before('').map { |input_line| input_line.grep_v '' }

  # Convert the boards as array of arrays of strings
  boards_as_array_of_strings.map { |string_board| string_board.map(&:split) }
end

def mark_board(board, drawing_number)
  board.map do |line|
    line.map { |board_number| board_number == drawing_number ? 'x' : board_number }
  end
end

def board_won?(marked_board)
  # Checks if there are the numbers are in the same line
  validated_line = marked_board.any?(%w[x x x x x])

  # Checks if all the numbers are in the same column
  column_index = 0
  check_column = []
  5.times do
    line1 = marked_board[0][column_index]
    line2 = marked_board[1][column_index]
    line3 = marked_board[2][column_index]
    line4 = marked_board[3][column_index]
    line5 = marked_board[4][column_index]
    check_column << [line1, line2, line3, line4, line5]
    column_index += 1
  end
  validated_column = check_column.any?(%w[x x x x x])

  # Returns the result of the board
  validated_line || validated_column
end

def calculate_score(winning_board, called_number)
  # Eliminate the marked numbers
  remaining_numbers = winning_board.flatten.reject { |num| num == 'x' }.map(&:to_i)
  remaining_numbers.sum * called_number.to_i
end

def first_winning_board(boards, drawing_numbers)
  game_over = false
  drawing_index = 0
  winning_board = []

  until game_over
    # Draw a new number
    called_number = drawing_numbers[drawing_index]
    # puts "Called number = #{called_number}"

    # Mark all the boards
    boards = boards.map { |board| mark_board(board, called_number) }

    # Check all the boards
    boards.each do |board|
      winning_board = board
      game_over = board_won?(board)
      break if board_won?(board)
    end
    drawing_index += 1 unless game_over
  end
  puts "Last called number: #{called_number}"
  puts "Winning board: #{winning_board}"
  puts "Final score: #{calculate_score(winning_board, called_number)}"
end

def last_winning_board(boards, drawing_numbers)
  game_over = false
  drawing_index = 0
  remaining_boards = boards

  until game_over
    # Draw a new number
    called_number = drawing_numbers[drawing_index]
    # puts "Called number = #{called_number}"

    # Mark all the boards
    remaining_boards = remaining_boards.map { |board| mark_board(board, called_number) }

    # Check all the remaining boards
    remaining_boards.each do |board|
      remaining_boards.delete(board) if board_won?(board) && remaining_boards.count != 1
    end

    drawing_index += 1
    game_over = remaining_boards.count == 1 && board_won?(remaining_boards.first)
  end
  last_winning_board = remaining_boards.first

  puts "Last called number: #{called_number}"
  puts "Last winning board: #{last_winning_board}"
  puts "Final score: #{calculate_score(last_winning_board, called_number)}"
end

# SETUP
input = File.read('inputs/day4_input.txt').lines.map { |line| line.to_s.strip }
drawing_numbers = input.shift.split(',')
boards = boards(input)

# Tests
# test_input = File.read('inputs/day4_test.txt').lines.map { |line| line.to_s.strip }
# test_drawing_numbers = test_input.shift.split(',')
# test_boards = boards(test_input)

puts '--- Part One ---'
first_winning_board(boards, drawing_numbers)
# first_winning_board(test_boards, test_drawing_numbers)

puts '--- Part Two ---'
last_winning_board(boards, drawing_numbers)
# last_winning_board(test_boards, test_drawing_numbers)
