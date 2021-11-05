# frozen_string_literal: true

Rails.application.routes.draw do
  get 'book_rentals/index'
  get 'members/index'
  get 'sessions/new'
  get 'books/new'
  get 'books/index'
  resources :books
  resources :members
  resources :book_rentals
  resources :returns, only: %i[create new]
  resources :member_book_rentals, only: %i[index]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'books#index'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
end
