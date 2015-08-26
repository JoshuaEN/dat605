Rails.application.config.middleware.use OmniAuth::Builder do
	provider :developer, fields: [:name , :nickname], uid_field: :name unless Rails.env.production?
	provider :google_oauth2, Rails.configuration.ENV["GOOGLE_CLIENT_ID"], Rails.configuration.ENV["GOOGLE_CLIENT_SECRET"] #if Rails.env.production?
	#provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
	#provider :openid, :store => OpenID::Store::Filesystem.new('/tmp')
end