class Float
  
  def to_time
    [self.floor, ":", (frac = ((self - self.floor)*60).round) <= 9 ? "0" + frac.to_s : frac].join
  end
  
end