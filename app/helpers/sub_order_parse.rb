require 'csv'

module SubOrderParse
  extend self
  
  def load_data
    CSV.foreach("sub_trans_data.csv", headers:true) do |row|
      o = Order.new
      o.number = row[0]
      o.created_at = Date.strptime(row[1], '%m/%d/%y')
      o.total = row[3].to_i / 100.0
      o.trans_type = 's'
      customer = Customer.find_by(email: row[4])
      if customer.nil?
        o.customer = Customer.create(email: row[4], name: row[2])
      else
        o.customer = customer
      end
      o.save
    end
  end  
end