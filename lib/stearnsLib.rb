class Array

  def delta_math(delta, &prc)
    self.dup.delta_math!(delta, &prc)
  end

  def delta_math!(delta, &prc)
    prc = Proc.new{ |x,y| x + y } unless prc
    self.each_with_index { |item,index| self[index] = prc.call(item,delta[index]) }
  end
end
