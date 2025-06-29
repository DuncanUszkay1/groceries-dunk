class ListItemController < ApplicationController
  skip_before_action :verify_authenticity_token

  def add_to_list
    ListItem.add_to_list(name: params[:name])

    redirect_to action: "all"
  end

  def mark_purchased
    ListItem.mark_purchased(id: params[:id])

    redirect_to action: "all"
  end

  def edit_name
    ListItem.edit_name(id: params[:id], name: params[:name])

    redirect_to action: "all"
  end

  def all
    @list_items = ListItem.all.order(id: :desc)
  end

  def delete
    ListItem.delete(id: params[:id])

    redirect_to action: "all"
  end

  def delete_all
    ListItem.delete_all

    redirect_to action: "all"
  end

  def mark_all_as_purchased
    ListItem.mark_all_as_purchased

    redirect_to action: "all"
  end
end
