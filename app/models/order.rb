class Order < ActiveRecord::Base
  belongs_to :customer
  validates_uniqueness_of :order_number
  validates_presence_of :order_number
end
