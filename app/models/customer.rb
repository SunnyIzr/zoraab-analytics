class Customer < ActiveRecord::Base
  has_many :orders
  validates_uniqueness_of :email
  validates_presence_of :email
end
