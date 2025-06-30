class ListItemController < ApplicationController
  skip_before_action :verify_authenticity_token

  def add_to_list
    handle_name_too_long_errors do 
      ListItem.add_to_list(name: params[:name])

      redirect_to action: "all"
    end
  end

  def mark_purchased
    handle_not_found_errors do 
      ListItem.mark_purchased(id: params[:id])

      redirect_to action: "all"
    end
  end

  def edit_name
    handle_not_found_errors do 
      handle_name_too_long_errors do
        ListItem.edit_name(id: params[:id], name: params[:name])

        redirect_to action: "all"
      end
    end
  end

  def all
    @list_items = ListItem.all.order(id: :desc)
  end

  def delete
    handle_not_found_errors do 
      ListItem.delete(id: params[:id])

      redirect_to action: "all"
    end
  end

  def delete_all
    ListItem.delete_all

    redirect_to action: "all"
  end

  def mark_all_as_purchased
    ListItem.mark_all_as_purchased

    redirect_to action: "all"
  end

  private

  def handle_name_too_long_errors 
    yield
  rescue ListItem::NameTooLong => e
    redirect_to action: "all", flash: {error: e.message}
  end

  def handle_not_found_errors 
    yield
  rescue ListItem::NotFound => e
    redirect_to action: "all", flash: {error: e.message}
  end
end
