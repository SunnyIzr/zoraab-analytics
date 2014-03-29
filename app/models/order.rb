class Order < ActiveRecord::Base
  belongs_to :customer
  validates_uniqueness_of :number
  validates_presence_of :number
  
  def self.shopify(order)
    new_order = self.new(created_at: order[:created_at], number: order[:number], total: order[:total])
    new_order.customer = Customer.find_or_create_by(email: order[:email], name: order[:billing_address][:name])
    new_order.save
  end
end
