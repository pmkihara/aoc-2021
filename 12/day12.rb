# SETUP - INPUT
input = File.read('inputs/day12_input.txt').lines.map { |line| line.strip.split('-') }.sort

# SETUP - TEST
# test = File.read('inputs/day12_example.txt').lines.map { |line| line.strip.split('-') }.sort

def small?(node)
  node.match?(/[a-z]+/) && node != 'end'
end

def revisited_twice?(node, route)
  # Condition 1: Start node
  # Condition 2: Small node AND Appears once && One small node (self or other) appears twice in the route
  (small?(node) && route.include?(node) && route.select { |n| small?(n) }.tally.values.any?(2))
end

def visit_nodes(route, paths = [])
  start_node = route.last

  # Breakpoint
  return route if start_node == 'end'

  # Select paths with same start node and remove the start node the paths' nodes
  paths_with_start_node = paths.select { |path| path.any?(start_node) }
  nodes_in_paths = paths_with_start_node.flatten.uniq - [start_node]

  # Selects nodes that can't be reused
  not_reusable_nodes = nodes_in_paths.select { |node| route.include?(node) && small?(node) }

  # Remove the nodes that have been revisited
  visitable_nodes = nodes_in_paths - not_reusable_nodes - ['start']

  # Remove the paths with nodes that can't be reused for better performance
  paths = paths.reject { |p| p.intersection(not_reusable_nodes).any? }

  visitable_nodes.map do |node|
    visit_nodes(route + [node], paths)
  end
end

def visit_nodes_with_counter(route, paths = [])
  start_node = route.last

  # Breakpoint
  return route if start_node == 'end'

  # Get nodes in paths with same start node and remove the start node the paths' nodes
  nodes_in_paths = paths.select { |path| path.any?(start_node) }.flatten.uniq - [start_node]

  # Select nodes that can't be reused
  # Condition: Small node AND Appears once && One small node (self or other) appears twice in the route
  small_nodes = route.flatten.grep(/[a-z]+/)
  not_reusable_nodes = small_nodes.select { |node| route.include?(node) && small_nodes.tally.values.any?(2) } + ['start']

  # Remove the nodes that have been revisited
  visitable_nodes = nodes_in_paths - not_reusable_nodes

  # Remove the paths with nodes that can't be reused for better performance
  paths = paths.reject { |p| p.intersection(not_reusable_nodes).any? }

  visitable_nodes.map do |node|
    visit_nodes_with_counter(route + [node], paths)
  end
end

def flatten_until_2_levels(array, result = [])
  array.each do |elem|
    # Calls the function again if the first result is an array
    if elem.first.instance_of?(Array)
      flatten_until_2_levels(elem, result)
    else
      # Filters the result to choose only routes that are not empty
      result << elem unless elem.empty?
    end
  end
  result
end

def solve_part_1!(input)
  paths = input

  # Call the recursive function
  result = visit_nodes(['start'], paths)
  flatten_until_2_levels(result)
end

def solve_part_2!(input)
  paths = input

  # Call the recursive function
  # visit_nodes_with_counter(%w(start A b A b A), paths)
  result = visit_nodes_with_counter(['start'], paths)
  flatten_until_2_levels(result)
end

# RESULTS
# puts '--- Part One ---'
# print 'Test - '
# p solve_part_1!(test).length
# print 'Input - '
# p solve_part_1!(input).length
# puts '--- Part Two ---'
# print 'Test - '
# p solve_part_2!(test).length
# print 'Input - '
p solve_part_2!(input).length
