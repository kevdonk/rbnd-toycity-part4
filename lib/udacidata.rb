require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
  @@file = File.dirname(__FILE__) + "/../data/data.csv"
  create_finder_methods("brand","name")

  def self.create(attributes = nil)

    # create product
    prod = self.new(attributes)

    # if product is not yet in database
    if not prod.product_exists_in_db?(prod.id)
      # save in db
      save_to_db([prod.id].concat(attributes.values))
    end
    # return
    return prod
  end

  def self.all
    products = []
    entries = CSV.foreach(@@file, headers: true) do |row|
      prod_attributes = {id: row['id'], brand: row['brand'], name: row['product'], price: row['price']}
      products.push(Product.new(prod_attributes))
    end
    products
  end

  def self.first(n=1)
    n==1 ? all.first : all.first(n)
  end

  def self.last(n=1)
    n==1 ? all.last : all.last(n)
  end

  def self.find(id)
    found = all.select {|product| product.id == id}.first
    if found
      return found
    else
      raise ProductNotFoundError
    end
  end

  def self.destroy(id)
    deleted_product = find(id)
    list_without_deleted_product = all.delete_if { |product| product.id == id }
    overwrite_database(list_without_deleted_product)
    if deleted_product
      return deleted_product
    else
      raise ProductNotFoundError
    end
  end

  def self.save_to_db(attributes)
    CSV.open(@@file, "ab") do |csv|
      csv << attributes
    end
  end

  def self.overwrite_database(products)
    new_entries = CSV.open(@@file, "wb") do |csv|
      csv << ["id", "brand", "product", "price"]
      products.each do |product|
        csv << [product.id, product.brand, product.name, product.price]
      end
    end
  end

  def self.where(attributes)
    all.select {|entry| entry.send(attributes.keys[0]) == attributes.values[0]}
  end

  def product_exists_in_db?(product_id)
    if CSV.foreach(@@file, headers: true) do |entry|
        if entry['id'] == product_id
          return true
        end
      end
    end
  end

  def update(attributes={})
    Product.destroy(self.id)
    @name = attributes[:name] || @name
    @brand = attributes[:brand] || @brand
    @price = attributes[:price] || @price
    Product.create(id: self.id, brand: self.brand, name: self.name, price: self.price)
    Product.overwrite_database(Product.all)
    return self
  end
end
