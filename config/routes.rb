Rails.application.routes.draw do
  post 'list_item/add_to_list'
  post 'list_item/mark_purchased'
  post 'list_item/edit_name'
  post 'list_item/delete'
  post 'list_item/mark_all_as_purchased'
  post 'list_item/delete_all'
  get 'list_item/all'
  resources :widgets

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"

  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
