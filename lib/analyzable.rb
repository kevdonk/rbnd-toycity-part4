require_relative 'count_by'

module Analyzable
  create_counter_methods("brand", "name")
  def average_price(products)
    total = 0
    products.each do |product|
      total += product.price.to_f
    end
    total = (total / products.size).round(2)
  end
  def print_report(products)
    report = "Inventory by Brand\n"
    report << hash_to_string(count_by_brand(products))
    report << "Inventory by Name\n"
    report << hash_to_string(count_by_name(products))
    puts report
    report
  end
  def hash_to_string(hash)
    hash.map{|key, value| "\t- #{key}: #{value}\n"}.join('')  
  end
end
