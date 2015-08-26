class User < ActiveRecord::Base

	has_many :entries, inverse_of: :user
	has_many :favorites, inverse_of: :user

	validates :auth_provider, presence: true, uniqueness: { scope: :auth_uid}
	validates :auth_uid, presence: true

	validates :username, length: { in: 1..20}, uniqueness: true, format: { with: /\A[a-zA-Z0-9\-]+\z/, message: "can only contain A-Z, 0-9, and dash (-)" }, unless: :username_is_auth?
	validates :display_name, length: { in: 1..30}, format: { with: /\A[a-zA-Z0-9_ \-]+\z/, message: "can only contain A-Z, 0-9, underscore (_), space ( ), and dash (-)" }, unless: :display_name_is_auth?
	validates :session_key, uniqueness: true, if: Proc.new {|u| u.session_key.present? }

	validates :is_admin, inclusion: [true, false]
	validates :is_banned, inclusion: [true, false]

	before_validation {
		self.username = self.username.strip unless self.username.nil?
		self.display_name = self.display_name.strip unless self.display_name.nil?

		true
	}

	def session_key= value
		if value.nil?
			self[:session_key] = nil
		else
			self[:session_key] = User.session_key_hasher value
		end
	end

	def self.find_by_session_key key
		return nil if key.nil?
		find_by(session_key: User.session_key_hasher(key))
	end

	def self.find_by_provider_uid provider, uid
		find_by auth_provider: provider, auth_uid: uid
	end

	def self.build_from_auth provider, uid
		User.new auth_provider: provider, auth_uid: uid, username: auth_key(provider, uid), display_name: auth_key(provider, uid)
	end

	def auth_key
		User.auth_key auth_provider, auth_uid
	end

	def self.auth_key provider, uid
		"#{provider}.#{uid}"
	end

	private

		def username_is_auth?
			return false unless auth_key == username
			true
		end

		def display_name_is_auth?
			return false unless auth_key == display_name
			true
		end

		def self.generate_session_key
			SecureRandom.hex 32
		end

		def self.session_key_hasher key
			Digest::SHA256.hexdigest key
		end
end
