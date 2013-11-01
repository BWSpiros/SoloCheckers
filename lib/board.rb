require './Checkers.rb'
# REV: white space here
class Board
# REV: white space here
  attr_accessor :grid, :turn, :turn_array
# REV: white space here
  def initialize
    @grid = Array.new(8){Array.new(8)}
    @turn = 0
    # REV: :red and :black are not much longer and
    #      are way more expressive.
    @turn_array = [:r, :b]
  end

  # REV: It's a little debatable, but I think that moving this
  #      function and get_input to a separate game class
  #      could help separate your concerns a little better.
  def game_loop
    # REV: Looks like you depend on return statements to break this
    #      while loop. Better off using do loop in that case.
    while true
      # REV: This along with the if statement a little further down
      #      looks like your win condition code. Your game loop
      #      would be more readable if you abstracted the win
      #      condition stuff into a helper function.
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

  # REV: get_input is not a great name for this method, since it 
  #      makes moves and therefore does more than just getting
  #      input.
  def get_input(error = nil, player = turn_array[turn % 2])
    # Rev: This is the ideal situation for begin/rescue. Much less 
    #      cumbersome than having to rely on toggling 
    #      the  moved variable to true/false.
    moved = false
    until moved
      display
      error = "\n#{error}" unless error.nil?
      puts "Input expected in the form of '0,1'"
      puts "#{error}Which piece to move?"
      piece = gets.chomp.split(',').map!{|i| i.to_i}
      # REV: The next if line below is just way to long. Break it across two lines.
      #      As a rule of thumb, anything > 80 chars is too much.
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
    # REV: White space here. Doing so helps highlight what this function returns (i.e. moves)
    moves
  end

  # REV: While it doesn't matter so much right now, the second we start using
  #      rpec, you'll be better off having this function build and return
  #      a string.
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


  # REV: This function has a lot of repetition.
  #      Good candidate for refactoring on that basis alone.
  def populate_board
    grid[0].map!.with_index {|x, index| Checker.new(self, [0,index], :b) if (index+1) % 2 ==0}
    grid[1].map!.with_index {|x, index| Checker.new(self, [1,index], :b) if (index+1) % 2 !=0}
    grid[2].map!.with_index {|x, index| Checker.new(self, [2,index], :b) if (index+1) % 2 ==0}

    # REV: While it's impressive that you got this on one line, it is not readable.
    grid[-3].map!.with_index {|x, index| Checker.new(self, [-3 % grid.length ,index], :r) if (index+1) % 2 !=0}
    grid[-2].map!.with_index {|x, index| Checker.new(self, [-2 % grid.length,index], :r) if (index+1) % 2 ==0}
    grid[- 1].map!.with_index {|x, index| Checker.new(self, [-1 % grid.length,index], :r) if (index+1) % 2 !=0}

    # REV: No need to use return here. Better just to implicit return.
    return nil
  end

  # REV: Not sure why you monkey patch inspect here.
  def inspect
    nil
  end

end

b = Board.new
# REV: Would have preferred to have seen populate_board called as part
#      of the board's initialization function. Doing so would also
#      allow you to make the function private.
b.populate_board
b.game_loop
