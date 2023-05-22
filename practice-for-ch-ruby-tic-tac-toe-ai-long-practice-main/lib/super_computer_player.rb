require_relative 'tic_tac_toe_node'
require "byebug"

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
  # debugger
    dup_board = game.board.dup
    next_mark = mark == :x ? :o : :x
    node = TicTacToeNode.new(dup_board,mark)
    node.children.each do |child|
      # print "we are looking at this child's move: #{child.prev_move_pos} \n"
      # print "is this child a winning node for #{mark}?: #{child.winning_node?(mark)} \n"
      return child.prev_move_pos if child.winning_node?(mark)
    end
    node.children.each do |child|
      return child.prev_move_pos if !child.losing_node?(mark)
    end
    raise "Something's wrong! I always win or tie!"
  end

end



if $PROGRAM_NAME == __FILE__
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end