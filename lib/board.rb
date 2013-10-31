require './Checkers.rb'
class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8){Array.new(8)}
  end

  def display
    puts "\n\n\n"
    grid.each_with_index do |row, rindex|
      row.each_with_index do |square, cindex|
        if grid[rindex][cindex].class == Checker
          print " #{grid[rindex][cindex].player.to_s} "
        else
          print " _ "
        end
      end
      puts ""
    end
    puts "\n\n\n"
    nil
  end


  # def []
#   end
#
#   def []=
#
#   end
#

def inspect
  nil
end

end
