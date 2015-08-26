Rails.application.routes.draw do
	root 'entries#index'

	get 'search', controller: :entries, action: :index, search: true

	resource :session, path: 'auth', only: [] do
		match ':provider/callback', action: :create, via: [:get, :post]
		post 'failure', action: :failure
		post 'destroy', action: :destroy, as: :destroy

		# This is overridden by Omniauth for valid providers
		# Concept from https://github.com/intridea/omniauth/issues/484#issuecomment-3097306
		get ':provider', action: :invalid_provider, as: :auth
	end

	resources :users, path: 'u', only: [:edit, :update, :destroy] do
		post 'ban', action: :ban, on: :member
	end
	resources :entries, path: 'e', only: [:show, :new, :create, :destroy] do
		post 'favorite', action: :favorite
		post 'unfavorite', action: :unfavorite
	end

	get 'about', controller: :static, action: :about

	get '*path', to: redirect('/') unless Rails.env.development?
end
