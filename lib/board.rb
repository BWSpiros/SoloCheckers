require './Checkers.rb'
class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8){Array.new(8)}
  end

  def game_loop

  end

  def get_input(error = nil)
    while true
      display
      error = "\n#{error}" unless error.nil?
      puts "Input expect in the form of '0,1'"
      puts "#{error}Which piece to move?"
      piece = gets.chomp.split(',').map!{|i| i.to_i}
      next if grid[piece[0]][piece[1]].class != Checker
      p = grid[piece[0]][piece[1]]
      options = (p.get_allowed_moves)
      display(options)
      puts "Where would you like to move? (select a choice)"
      p.perform_move(options[gets.chomp.to_i])
    end
  end

  def display(options = [])
    system("clear")
    p options
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
    grid.flatten.compress
  end


  def populate_board
    grid[0].map!.with_index {|x, index| Checker.new(self, [0,index], :b) if (index+1) % 2 ==0}
    grid[1].map!.with_index {|x, index| Checker.new(self, [1,index], :b) if (index+1) % 2 !=0}
    grid[2].map!.with_index {|x, index| Checker.new(self, [2,index], :b) if (index+1) % 2 ==0}

    grid[-3].map!.with_index {|x, index| Checker.new(self, [-3,index], :r) if (index+1) % 2 !=0}
    grid[-2].map!.with_index {|x, index| Checker.new(self, [-2,index], :r) if (index+1) % 2 ==0}
    grid[- 1].map!.with_index {|x, index| Checker.new(self, [-1,index], :r) if (index+1) % 2 !=0}
    return nil
  end

  def inspect
    nil
  end

end
