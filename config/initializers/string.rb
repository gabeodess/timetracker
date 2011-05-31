class String #:nodoc:
    
  # ====================
  # = Instance Methods =
  # ====================
  def split_by_any(*args)
    string = self
    array = string.split(args.first)
    args.to_a.each do |splitter|
      array = array.map{|item| item.split(splitter)}.flatten
    end
    return array.reject{|item| item.blank?}
  end
  
  def email?
    self.match(Regex.email)
  end
  
  # =========
  # = Regex =
  # =========
  class Regex
    def self.email
      /^.+@.+\.[a-z]+$/
    end
  end
  
end