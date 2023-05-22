require_relative 'tree_node'
require "byebug"

class KnightPathFinder
  attr_reader :board, :position
  def initialize(start_pos = [0, 0])
    @position = start_pos
    @board = Array.new(8) {Array.new(8)}
    (0..7).each do |row|
      (0..7).each do |col|
        @board[row][col] = PolyTreeNode.new([row, col])
      end
    end
    @considered_positions = []
  end

  def self.valid_moves(pos)
    row, col = pos
    moves = [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[-1,2],[1,-2],[-1,-2]]
    valid_moves = []
    moves.each do |move|
      row_i, col_i = move
      row_new = row + row_i
      col_new = col + col_i
      if row_new.between?(0,7) && col_new.between?(0,7)
        valid_moves << move
      end
    end
    valid_moves
  end

  def new_move_positions(pos)
    row, col = pos
    new_moves = []
    valid_moves = KnightPathFinder.valid_moves(pos) 
    valid_moves.each do |move|
      row_i, col_i = move
      row_new = row + row_i
      col_new = col + col_i
      new_moves << move if !@considered_positions.include?([row_new,col_new])
    end
    new_positions = []
    new_moves.each do |move|
      row_i, col_i = move
      row_new = row + row_i
      col_new = col + col_i
      new_positions << [row_new, col_new]
      @considered_positions << [row_new, col_new]
    end
    new_positions
  end

  def build_move_tree(target_pos)
    row, col = @position
    row_t, col_t = target_pos
    queue = [board[row][col]] # contains only starting node
    considered = []
    until queue.empty?
      parent_node = queue.shift
      pos = parent_node.value
      if !considered.include?(pos)
        row, col = pos
        if parent_node == board[row_t][col_t]
          break
        else
          new_pos = new_move_positions(pos)
          new_pos.each do |new_pos|
            row_i, col_i = new_pos
            if !board[row][col].children.include?(new_pos)
              board[row][col].add_child(board[row_i][col_i])
            end
          end

          to_queue = []
          board[row][col].children.each do |child|
            to_queue << child if !considered.include?(child)
          end

          queue += to_queue
          queue.each do |el|
            print "#{el.value},"
          end
          print "]\n"
        end
        considered << pos
      end
    end
  end

  def find_path(end_pos)
    row, col = @position
    build_move_tree(end_pos)
    board[row][col].bfs(end_pos)
    trace_path_back(end_pos)
  end

  def trace_path_back(end_pos)
    row_e, col_e = end_pos
    path = []
    parent_node = board[row_e][col_e]
    until parent_node.value == @position
      path = path.unshift(parent_node.value)
      # print path.to_s + "\n"
      # print parent_node.value + "\n"
      parent_node = parent_node.parent
    end
    path.unshift(parent_node.value)
  end
end