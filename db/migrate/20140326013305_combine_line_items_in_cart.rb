class CombineLineItemsInCart < ActiveRecord::Migration
  def change
  	all_carts = Cart.all
  	all_carts.each do |cart|
  		product_ids = cart.line_items.map(&:product_id).uniq
  		product_ids.each do |product_id|
  			line_items = cart.line_items.where(product_id: product_id)
  			if  line_items.count > 1
  				li_count = line_items.count
  				line_items.delete_all
  				cart.line_items.create(product_id: product_id, quantity: li_count)
  			end
  		end
  	end
  end
end
