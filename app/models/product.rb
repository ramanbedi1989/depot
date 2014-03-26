class Product < ActiveRecord::Base
	default_scope { order(:title) }
	validates :title, :description, :image_url, presence: true
	validates :price, numericality: {greater_than_or_equal_to: 0.01}
	validates :title, uniqueness: true
	validates :image_url, format: {with: /\.(jpg|png|gif)\z/i, message: "should be of the required format"}

	has_many :line_items
	before_destroy :ensure_not_referenced_by_any_line_item

	def ensure_not_referenced_by_any_line_item
		if line_items.count.zero?
			true
		else
			errors.add(:base, "Line items present")
			false
		end
	end
end
