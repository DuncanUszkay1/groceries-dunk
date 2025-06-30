class ListItemController < ApplicationController
  skip_before_action :verify_authenticity_token

  rescue_from ActionController::ParameterMissing, :with => :bad_request

  NAME_TOO_LONG_MESSAGE = "Names can be no longer then #{ListItem::MAX_NAME_LENGTH} characters long."
  BAD_REQUEST_MESSAGE = "We're experiencing issues. Please try refreshing the page."

  def bad_request
    flash[:error] = BAD_REQUEST_MESSAGE 
    head :bad_request 
  end

  def add_to_list
    handle_name_too_long_errors do 
      ListItem.add_to_list(name: params.require(:name))

      redirect_to action: "all"
    end
  end

  def mark_purchased
    handle_not_found_errors do 
      ListItem.mark_purchased(id: params.require(:id))

      redirect_to action: "all"
    end
  end

  def edit_name
    handle_not_found_errors do 
      handle_name_too_long_errors do
        ListItem.edit_name(id: params.require(:id), name: params.require(:name))

        redirect_to action: "all"
      end
    end
  end

  def all
    @list_items = ListItem.all_by_creation_date
  end

  def delete
    handle_not_found_errors do 
      ListItem.delete(id: params.require(:id))

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
  rescue ListItem::NameTooLong
    flash[:error] = NAME_TOO_LONG_MESSAGE
    redirect_to action: "all"
  end

  def handle_not_found_errors 
    yield
  rescue ListItem::NotFound => e
    bad_request
  end
end
