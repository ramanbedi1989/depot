require 'digest/sha2'
class User < ActiveRecord::Base
	validates :name, presence: true, uniqueness: true
	validates :password, confirmation: true
	after_destroy :ensure_an_admin_remains

	attr_reader :password
	attr_accessor :password_confirmation

	validate :password_must_be_present

	def ensure_an_admin_remains
		if User.count.zero
			raise "Can't delete the last user"
		end
	end

	def self.authenticate(name, password)
		if user = User.find_by(name: name)
			if user.hashed_password == encrypt_password(password,user.salt)
				user
			end
		end
	end

	def self.encrypt_password(password, salt)
		Digest::SHA2.hexdigest(password + "wibble" + salt)
	end

	def password=(password)
		@password = password

		if password.present?
			generate_salt
			self.hashed_password = self.class.encrypt_password(password,self.salt)
		end
	end

	private 

	def password_must_be_present
		errors.add(:password, "must be present") unless hashed_password.present?
	end

	def generate_salt
		self.salt = self.object_id.to_s + rand.to_s
	end
end
