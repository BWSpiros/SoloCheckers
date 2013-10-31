require './Checkers.rb'
class Board
  attr_accessor :grid, :turn, :turn_array
  def initialize
    @grid = Array.new(8){Array.new(8)}
    @turn = 0
    @turn_array = [:r, :b]
  end

  def game_loop
    while true
      if get_all_moves([turn_array[turn % 2]]).flatten.length == 0
        display
        return print "\n#{@turn_array[(turn+1) % 2].to_s.upcase} wins!\n"
      end
      get_input
      self.turn += 1
      if all_pieces.length == 1
        display
        return print "\n#{all_pieces[0].player.to_s.upcase} wins!\n"
      end
    end
  end

  def get_input(error = nil, player = turn_array[turn % 2])
    moved = false
    until moved
      display
      error = "\n#{error}" unless error.nil?
      puts "Input expected in the form of '0,1'"
      puts "#{error}Which piece to move?"
      piece = gets.chomp.split(',').map!{|i| i.to_i}
      next if grid[piece[0]][piece[1]].class != Checker || grid[piece[0]][piece[1]].player != player
      p = grid[piece[0]][piece[1]]
      options = (p.get_allowed_moves)
      display(options)
      puts "Where would you like to move? (select a choice)"
      p.perform_move(options[gets.chomp.to_i])
      moved = true
    end
  end

  def get_all_moves(color = [:r, :b])
    moves = []
    all_pieces.each { |piece| moves << piece.get_allowed_moves if color.include? piece.player}
    p moves
    moves
  end

  def display(options = [])
    system("clear")
    dict = {:b => "Black", :r => "Red"}
    puts "#{dict[turn_array[turn % 2] ]}'s Turn"
    puts "\n\n\n"
    grid.each_with_index do |row, rindex|
      row.each_with_index do |square, cindex|
        if options.include? [rindex,cindex]
          print " #{options.index [rindex, cindex]} "
        elsif grid[rindex][cindex].class == Checker
          print " #{grid[rindex][cindex].player.to_s} "
        elsif grid[rindex][cindex] == nil
          print " _ "
        end
      end
      puts ""
    end
    puts "\n\n\n"
    nil
  end

  def all_pieces
    grid.flatten.compact
  end


  def populate_board
    grid[0].map!.with_index {|x, index| Checker.new(self, [0,index], :b) if (index+1) % 2 ==0}
    grid[1].map!.with_index {|x, index| Checker.new(self, [1,index], :b) if (index+1) % 2 !=0}
    grid[2].map!.with_index {|x, index| Checker.new(self, [2,index], :b) if (index+1) % 2 ==0}

    grid[-3].map!.with_index {|x, index| Checker.new(self, [-3 % grid.length ,index], :r) if (index+1) % 2 !=0}
    grid[-2].map!.with_index {|x, index| Checker.new(self, [-2 % grid.length,index], :r) if (index+1) % 2 ==0}
    grid[- 1].map!.with_index {|x, index| Checker.new(self, [-1 % grid.length,index], :r) if (index+1) % 2 !=0}
    return nil
  end

  def inspect
    nil
  end

end

b = Board.new
b.populate_board
b.game_loop