# SETUP - INPUT
input = File.read('inputs/day10_input.txt').lines.map{ |line| line.strip.to_s }

# SETUP - TEST
test = File.read('inputs/day10_example.txt').lines.map{ |line| line.strip.to_s }

CHUNKS = {
  ')' => '(',
  ']' => '[',
  '}' => '{',
  '>' => '<'
}

ERROR_VALUE = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

AUTOCOMPLETE = {
  '(' => 1,
  '[' => 2,
  '{' => 3,
  '<' => 4
}

def parse_line(line)
  string = line
  # find the first closing character
  char_index = string =~ /[>}\]\)]/
  until string.length.zero? || char_index.nil? || string[char_index - 1] != CHUNKS[string[char_index]]
    string.slice!(char_index - 1, 2)
    char_index = string =~ /[>}\]\)]/
  end

  if string.length.zero? || char_index.nil?
    return string
  elsif string[char_index - 1] != CHUNKS[string[char_index]]
    return string[char_index]
  end
end

def calc_autocomplete(string)
  chars = string.reverse.chars
  score = 0
  chars.each do |char|
    score = (score * 5) + AUTOCOMPLETE[char]
  end
  score
end

def solve!(lines)
  incomplete = []
  errors = []

  lines.each do |line|
    result = parse_line(line)
    CHUNKS.keys.include?(result) ? errors << result : incomplete << result
  end
  puts "Error sum = #{errors.map { |error| ERROR_VALUE[error] }.sum}"
  autocomplete = incomplete.map { |string| calc_autocomplete(string) }.sort
  puts "Autocomplete = #{autocomplete[autocomplete.length / 2]}"
end

# RESULTS
puts 'Test'
solve!(test)
puts 'Input'
solve!(input)
