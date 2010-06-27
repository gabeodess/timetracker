class String #:nodoc:
  
  def split_by_any(*args)
    string = self
    array = string.split(args.first)
    args.to_a.each do |splitter|
      array = array.map{|item| item.split(splitter)}.flatten
    end
    return array.reject{|item| item.blank?}
  end
  
  
end