require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
	fixtures :products

	test "buying a product" do
		LineItem.delete_all
		Order.delete_all
		ruby_book = products(:ruby)

		get "/"

		assert_response :success
		assert_template "index"

		xml_http_request :post, "/line_items", product_id: ruby_book.id
		assert_response :success

		cart = Cart.find(session[:cart_id])
		assert_equal 1,cart.line_items.count
		assert_equal ruby_book, cart.line_items.first.product


		get "/orders/new"

		assert_response :success
		assert_template "new"

		post_via_redirect "/orders", order: { name: "Raman Bedi", address: "1006", email: "ramanbedi1989@gmail.com", pay_type: "Check" }

		assert_response :success
		assert_template "index"
		orders = Order.all
		cart = Cart.find(session[:cart_id])
		assert_equal 1, orders.count
		assert_equal 0, cart.line_items.count
		assert_equal ruby_book, orders.first.line_items.first.product
		order = orders.first

		assert_equal "Raman Bedi", order.name
		assert_equal "1006", order.address
		assert_equal "ramanbedi1989@gmail.com", order.email
		assert_equal "Check", order.pay_type

		mail = ActionMailer::Base.deliveries.last
		assert_equal "Raman Bedi", mail.from
		assert_equal ["ramanbedi1989@gmail.com"], mail.to
		assert_equal "Pragmatic Store Order Confirmation", mail.subject
	end
end
