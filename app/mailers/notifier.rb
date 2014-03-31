class Notifier < ActionMailer::Base
  default from: "Raman Bedi"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_recieved.subject
  #
  def order_recieved(order)
    @order = order

    mail to: order.email, subject: "Pragmatic Store Order Confirmation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifier.order_shipped.subject
  #
  def order_shipped(order)
  	@order = order
    mail to: order.email, subject: 'Pragmatic Store Order Shipped'
  end
end
