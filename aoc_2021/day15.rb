# frozen_string_literal: false

# SETUP
example = File.read('inputs/day15_example.txt').lines.map { |line| line.strip.chars }
input = File.read('inputs/day15_input.txt').lines.map { |line| line.strip.chars }

def create_nodes_with_times(input, times)
  nodes = {}
  n_rows = input.length
  n_cols = input[0].length

  input.each_with_index do |row, row_index|
    times.times do |row_times|
      row.each_with_index do |col, col_index|
        times.times do |col_times|
          value = col.to_i + row_times + col_times
          col_coord = col_index + (col_times * n_cols)
          row_coord = row_index + (row_times * n_rows)

          nodes[[col_coord, row_coord]] = {
            value: value >= 10 ? value - 9 : value,
            visited: false,
            position: [col_coord, row_coord],
            distance: Float::INFINITY
          }
        end
      end
    end
  end
  nodes
end

def neighbours(node, nodes)
  neighbours = []
  node_x = node[:position][0]
  node_y = node[:position][1]
  neighbours.push(
    nodes[[node_x - 1, node_y]],
    nodes[[node_x + 1, node_y]],
    nodes[[node_x, node_y - 1]],
    nodes[[node_x, node_y + 1]]
  )
  neighbours.compact
end

def heap_sort(array)
  size = array.length
  # Add empty element at beginning of array to be the root
  root_array = [nil] + array

  i = size / 2
  while i.positive?
    heapify(root_array, i, size)
    i -= 1
  end

  while size > 1
    root_array[1], root_array[size] = root_array[size], root_array[1]
    size -= 1
    heapify(root_array, 1, size)
  end
  root_array.shift # get rid of the initial nil
  root_array
end

def heapify(array, parent_index, limit)
  root = array[parent_index]

  while (child_node_index = 2 * parent_index) <= limit
    if child_node_index < limit && array[child_node_index][:distance] > array[child_node_index + 1][:distance]
      child_node_index += 1
    end

    break if root >= array[child_node_index]

    array[parent_index] = array[child_node_index]
    parent_index = child_node_index
  end
  array[parent_index] = root
end

def visit_nodes(visited_nodes = {}, unvisited_nodes = {})
  # Dijkstra algorythm
  # 1. Break the recursion when all the nodes have been visited
  # 2. Get the neighbours of each visited node
  # 3. Update the neighbours distances
  # 4. Calculate the  new distance (sum of the distance of the source node and
  #    the value of the neighbour
  # 5. Update the neighbour distance if the new one is smaller than the old one
  #    or if the neighbour does not have the distance set yet and set the source
  #    node
  # 6. Get the node with the smallest distance
  # 7. Get all the nodes with the same distance as the closest in case of tie
  # 8. Mark the node as visited now that all the neighbours have been checked
  # 9. Remove the node from the unvisited_nodes
  # 10. Add the node to the visited_nodes
  # 11. Recursively visit the other nodes

  return visited_nodes if unvisited_nodes.empty?

  visited_nodes.each do |visited_coordinates, visited_node|
    neighbours = neighbours(visited_node, unvisited_nodes)

    neighbours.each do |neighbour|
      new_distance = visited_node[:distance] + neighbour[:value]
      if !neighbour[:distance] || new_distance < neighbour[:distance]
        neighbour[:distance] = new_distance
        neighbour[:source_position] = visited_coordinates
      end
    end
  end

  calculated_nodes = unvisited_nodes.select { |_coordinates, node| node[:distance] }
  closest_node = calculated_nodes.min { |a, b| a[1][:distance] <=> b[1][:distance] }[1]

  closest_nodes = unvisited_nodes.select { |_coordinates, node| node[:distance] == closest_node[:distance] }

  closest_nodes.each do |coordinates, node|
    node[:visited] = true

    unvisited_nodes.delete(node[:position])

    visited_nodes[coordinates] = node
  end

  visit_nodes(visited_nodes, unvisited_nodes)
end

def visit_nodes_with_queue(visited_nodes = {}, unvisited_nodes = {}, queue, end_node_position)
  # Dijkstra algorythm with queue
  # 1. Break the recursion when the end node is in the visited nodes
  # 2. Get the neighbours of each node in the queue
  # Mark the node as visited if no neighbours
  # 3. Calculate the  new distance (sum of the distance of the source node and
  #    the value of the neighbour)
  # 5. Update the neighbour distance if the new one is smaller than the old one
  #    or if the neighbour does not have the distance set yet and set the source
  #    node
  # 6. Search the index of the first element bigger than the neighbour and, if
  #    it exists, remove the last item of the queue and add the neighbour at the
  #    previously found index
  # 7. Get all the nodes with the same distance as the closest in case of tie
  # 8. Mark the node as visited now that all the neighbours have been checked
  # 9. Remove the node from the unvisited_nodes
  # 10. Add the node to the visited_nodes
  # 11. Recursively visit the other nodes

  return visited_nodes if unvisited_nodes.empty?
  # return visited_nodes if visited_nodes[end_node_position]

  queue.each_with_index do |node, i|
    neighbours = neighbours(node, unvisited_nodes)
    queue.delete_at(i) if neighbours.empty?

    neighbours.each do |neighbour|
      new_distance = node[:distance] + neighbour[:value]
      if new_distance < neighbour[:distance]
        neighbour[:distance] = new_distance
        neighbour[:source_position] = [node[:position]]
      end
    end
  end

  sorted_unvisited_nodes = heap_sort(unvisited_nodes.values)
  closest_distance = sorted_unvisited_nodes[0][:distance]
  p sorted_unvisited_nodes
  p closest_distance
  p '-------------------------------------------------------------------------'

  sorted_unvisited_nodes.each do |node|
    break if node[:distance] != closest_distance

    node[:visited] = true
    unvisited_nodes.delete(node[:position])
    visited_nodes[node[:position]] = node
    queue << node
    # p queue
  end

  queue = heap_sort(queue.uniq).first(1000)

  visit_nodes_with_queue(visited_nodes, unvisited_nodes, queue, end_node_position)
end

def solve_1!(input)
  nodes = create_nodes_with_times(input, 1)
  start_node = nodes[[0, 0]]
  start_node[:distance] = 0
  start_node[:visited] = true
  nodes.delete([0, 0])
  end_node_position = [input.length - 1, input[0].length - 1]
  # visited_nodes = visit_nodes({ [0, 0] => start_node }, nodes)
  visited_nodes = visit_nodes_with_queue({ [0, 0] => start_node }, nodes, [start_node], end_node_position)
  p visited_nodes[end_node_position][:distance]
end

def solve_2!(input)
  nodes = create_nodes_with_times(input, 5)
  start_node = nodes[[0, 0]]
  start_node[:distance] = 0
  start_node[:visited] = true
  nodes.delete([0, 0])
  end_node_position = [(input.length * 5) - 1, (input[0].length * 5) - 1]
  visited_nodes = visit_nodes_with_queue({ [0, 0] => start_node }, nodes, [start_node], end_node_position)
  p visited_nodes[end_node_position][:distance]
end

start_time = Time.now
solve_1!(example)
end_time = Time.now
p end_time - start_time
