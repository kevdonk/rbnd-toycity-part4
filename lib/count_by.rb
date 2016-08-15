class Module
  def create_counter_methods(*attributes)
    attributes.each do |attribute|
      #http://stackoverflow.com/questions/5470725/how-to-group-by-count-in-array-without-using-loop
      class_eval("def self.count_by_#{attribute}(products); products.each_with_object(Hash.new(0)) {|product, product_hash| product_hash[product.#{attribute}] += 1}; end")
    end
  end
end
