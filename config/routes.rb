# frozen_string_literal: true

Rails.application.routes.draw do
  get 'books/new'
  get 'books/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'application#hello'
end
