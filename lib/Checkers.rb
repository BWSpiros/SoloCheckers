class Checker

  attr_accessor :player, :king, :location, :board

  ATTACK = [[2,2], [2,-2], [-2, 2], [-2,-2]]
  LOOK_AHEAD = [[1,1], [1,-1], [-1, 1], [-1,-1]]

  def initialize(board, location, player = :r)
    @board = board.grid
    @player = player
    @location = location
    @king = false
  end

  def get_allowed_moves
    return determine_attacks if determine_attacks != []
    return default_moves
  end


  def default_moves
    direction = player == :r ? -1 : 1
    look, results = LOOK_AHEAD, []
    look = LOOK_AHEAD.keep_if{ |loc| loc[0] == direction } if self.king != true
    look.each{ |pos| results << location.delta_math(pos)}
    results.keep_if {|pos| move_on_board?(pos)}
  end

  def determine_attacks
    possibles = default_moves
    attacks = possibles.keep_if{ |mov| board[mov[0]][mov[1]].class == Checker && board[mov[0]][mov[1]].player != player}
    attacks.keep_if do |attack|
      jump = attack.delta_math(offset(attack))
      board[jump[0]][jump[1]].nil?
    end
  end

  def move_on_board?(coord)
    coord.all? { |x| (0..7).include? x }
  end

  def offset(tgt)
    location.delta_math(tgt){ |x,y| y-x }
  end

end

class Array

  def delta_math(delta, &prc)
    self.dup.delta_math!(delta, &prc)
  end

  def delta_math!(delta, &prc)
    prc = Proc.new{ |x,y| x + y } unless prc
    self.each_with_index { |item,index| self[index] = prc.call(item,delta[index]) }
  end
end
