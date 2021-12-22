# SETUP - INPUT
input = File.read('inputs/day13_input.txt').lines.map { |line| line.strip.split(',') }.group_by(&:length)

# SETUP - TEST
test = File.read('inputs/day13_example.txt').lines.map { |line| line.strip.split(',') }.group_by(&:length)

# Set paper
def set_paper(input)
  input[2].map { |coord| coord.map(&:to_i) }
end

def set_folds(input)
  input[1].flatten.map { |instruction| instruction.delete('fold along ').split('=') }
end

def fold_paper!(paper, instruction)
  fold_number = instruction.last.to_i

  if instruction.first == 'x'
    # Fold left
    folded_part = paper.select { |coord| coord.first > fold_number}
    original_part = paper.reject { |coord| coord.first >= fold_number}

    folded_part.each do |coord|
      coord[0] -= (coord[0] - fold_number) * 2
    end

  elsif instruction.first == 'y'
    # Fold up
    folded_part = paper.select { |coord| coord.last > fold_number}
    original_part = paper.reject { |coord| coord.last >= fold_number}

    folded_part.each do |coord|
      coord[1] -= (coord[1] - fold_number) * 2
    end
  end

  # Return the folded paper
  (folded_part + original_part).uniq
end

def fold_paper_with_size!(instruction, paper_set)
  paper = paper_set.first
  paper_size = paper_set.last
  fold_number = instruction.last.to_i

  if instruction.first == 'x'
    # Fold left
    folded_part = paper.select { |coord| coord.first > fold_number}
    original_part = paper.reject { |coord| coord.first >= fold_number}

    folded_part.each do |coord|
      coord[0] -= (coord[0] - fold_number) * 2
    end
    paper_size[0] = fold_number
  elsif instruction.first == 'y'
    # Fold up
    folded_part = paper.select { |coord| coord.last > fold_number}
    original_part = paper.reject { |coord| coord.last >= fold_number}

    folded_part.each do |coord|
      coord[1] -= (coord[1] - fold_number) * 2
    end
    paper_size[1] = fold_number
  end

  # Return the folded paper
  paper = (folded_part + original_part).uniq
  [paper, paper_size]
end

def solve_part_1!(input)
  # Separate the paper coordinates in the input
  paper = set_paper(input)

  # Separate the fold instructions in the input
  instructions = set_folds(input)

  # Get the first instruction
  instruction = instructions.first

  # Fold the paper
  paper = fold_paper!(paper, instruction)

  # Calculate the number of dots (not marked parts)
  p paper.length
end

def draw(paper_set)
  paper = paper_set.first
  paper_size = paper_set.last

  # Make blank map
  map = []
  paper_size[1].times { map << '.' * paper_size[0] }

  # Fill the map with the coords
  paper.sort.each do |coord|
    map[coord.last][coord.first] = '#'
  end

  map.each { |row| puts row }
end

def solve_part_2!(input)
  # Separate the paper coordinates in the input
  paper = set_paper(input)

  # Calculate paper size
  paper_size = paper.transpose.map{ |a| a.max + 1 }

  paper_set = [paper, paper_size]

  # Separate the fold instructions in the input
  instructions = set_folds(input)

  instructions.each do |instruction|
    paper_set = fold_paper_with_size!(instruction, paper_set)
  end

  draw(paper_set)
end

# solve_part_1!(test)
# solve_part_1!(input)

# solve_part_2!(test)
solve_part_2!(input)
