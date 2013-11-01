# REV: Wasn't really sure what this file did before opening it. Could use a
#      clearer filename.
# 
# Rev: Also, doesn't look like any other file requires this one. Maybe
#      get rid of it then?
class Array

  def delta_math(delta, &prc)
    self.dup.delta_math!(delta, &prc)
  end

  def delta_math!(delta, &prc)
    prc = Proc.new{ |x,y| x + y } unless prc
    # Rev: The line below is long (83 chars). Better to break it over multiple lines
    #  for readability.
    self.each_with_index { |item,index| self[index] = prc.call(item,delta[index]) }
  end
end
