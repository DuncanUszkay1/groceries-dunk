# frozen_string_literal: true

Rails.application.routes.draw do
  post 'list_item/add_to_list'
  post 'list_item/mark_purchased'
  post 'list_item/edit_name'
  post 'list_item/delete'
  post 'list_item/mark_all_as_purchased'
  post 'list_item/delete_all'
  get 'list_item/all'

  root 'list_item#all'
end
