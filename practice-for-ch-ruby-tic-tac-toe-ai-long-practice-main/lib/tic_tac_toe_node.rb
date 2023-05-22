require_relative 'tic_tac_toe'
require "byebug"
class TicTacToeNode
  attr_accessor :board, :next_mover_mark, :prev_move_pos, :parent
  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
    @children = []
    @parent = nil
  end

  def losing_node?(evaluator)
    # debugger
    if @board.won?
      return @board.winner != evaluator
    elsif self.next_mover_mark == evaluator
      return self.children.all? {|child| child.losing_node?(evaluator)}
    elsif self.next_mover_mark != evaluator
      return self.children.any? {|child| child.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    if @board.won?
      return @board.winner == evaluator
   elsif self.next_mover_mark == evaluator
      return self.children.any? {|child| child.winning_node?(evaluator)}
    elsif self.next_mover_mark != evaluator
      return self.children.all? {|child| child.winning_node?(evaluator)}
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    @board.open_positions.each do |open_pos|
      board_dup = @board.dup
      board_dup[open_pos] = next_mover_mark
      next_move = next_mover_mark == :x ? :o : :x
      new_node = TicTacToeNode.new(board_dup,next_move,open_pos)
      @children << new_node
      new_node.parent = self
    end
    @children
  end
end