Order.transaction do
	(1..100).each do |count|
		Order.create(name: "#{count}", address: "##{count}, sector - #{count}", email: "howareyou@how.com", pay_type: "Check")
	end
end