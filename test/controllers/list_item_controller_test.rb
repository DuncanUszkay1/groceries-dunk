require "test_helper"

class ListItemControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchased_item = list_items(:purchased_jar)
    @unpurchased_item = list_items(:unpurchased_potato)
  end

  test "#add_to_list with a valid name should create the entry and redirect to all" do
    item_name = "yam"

    assert_difference "ListItem.count", 1 do
      post list_item_add_to_list_url, params: { name: item_name }
    end

    assert_equal item_name, ListItem.last.name
    assert_all_redirect
  end

  test "#add_to_list with a name that is too long should redirect to all with a flashed error" do
    item_name = "a"*(ListItem::MAX_NAME_LENGTH + 1)

    assert_difference "ListItem.count", 0 do
      post list_item_add_to_list_url, params: { name: item_name }
    end

    assert_name_length_redirect
  end

  test "#add_to_list without a name redirects with a 400 status and error flash" do
    assert_difference "ListItem.count", 0 do
      post list_item_add_to_list_url
    end

    assert_bad_request
  end

  test "#mark_purchased with a valid ID marks the entry as purchased" do 
    refute @unpurchased_item.purchased

    assert_difference "ListItem.where(purchased:true).count", 1 do
      post list_item_mark_purchased_url, params: { id: @unpurchased_item.id }
    end

    assert @unpurchased_item.reload.purchased
    assert_all_redirect
  end

  test "#mark_purchased with an invalid ID returns a 400" do
    assert_difference "ListItem.where(purchased:true).count", 0 do
      post list_item_mark_purchased_url, params: { id: "random" }
    end

    assert_bad_request
  end

  test "#mark_purchased without an ID returns a 400" do
    assert_difference "ListItem.where(purchased:true).count", 0 do
      post list_item_mark_purchased_url
    end

    assert_bad_request
  end

  test "#edit_name with a valid ID and name changes the name of the item" do 
    new_name = "yam"

    refute_equal @unpurchased_item.name, new_name

    post list_item_edit_name_url, params: { id: @unpurchased_item.id, name: new_name }

    assert_equal new_name, @unpurchased_item.reload.name
    assert_all_redirect
  end

  test "#edit_name with an invalid ID returns a 400" do
    post list_item_edit_name_url, params: { id: "random", name: "yam" }

    assert_bad_request
  end

  test "#edit_name without an ID returns a 400" do
    post list_item_edit_name_url, params: { name: "yam" }

    assert_bad_request
  end

  test "#edit_name with an invalid name redirects with an error flash and a 422 status" do
    post list_item_edit_name_url, params: { id: "random", name: "a"*(ListItem::MAX_NAME_LENGTH + 1) }

    assert_name_length_redirect
  end

  test "#edit_name without a name returns a 400" do
    post list_item_edit_name_url, params: { id: @unpurchased_item.id }

    assert_bad_request
  end

  test "#all returns a 200" do
    get list_item_all_url

    assert_response 200
  end

  test "#delete with a valid ID marks the entry as purchased" do 
    assert_difference "ListItem.count", -1 do
      post list_item_delete_url, params: { id: @unpurchased_item.id }
    end

    assert_all_redirect
  end

  test "#delete with an invalid ID returns a 400" do
    assert_difference "ListItem.count", 0 do
      post list_item_delete_url, params: { id: "random" }
    end

    assert_bad_request
  end

  test "#delete without an ID returns a 400" do
    assert_difference "ListItem.count", 0 do
      post list_item_delete_url
    end

    assert_bad_request
  end

  test "#delete_all deletes all list items and redirects to all" do
    assert_difference "ListItem.count", -ListItem.count do
      post list_item_delete_all_url
    end

    assert_equal 0, ListItem.count

    assert_all_redirect
  end

  test "#mark_all_as_purchased marks all line items as purchased and redirects to all" do
    assert_difference "ListItem.where(purchased: true).count", ListItem.where(purchased: false).count do
      post list_item_mark_all_as_purchased_url
    end

    assert_equal 0, ListItem.where(purchased: false).count

    assert_all_redirect
  end


  private

  def assert_bad_request
    assert_response 400
    assert_equal ListItemController::BAD_REQUEST_MESSAGE, flash[:error]
  end

  def assert_name_length_redirect
    assert_redirected_to %r(\Ahttp://www.example.com/list_item/all)
    assert_equal ListItemController::NAME_TOO_LONG_MESSAGE, flash[:error]
  end

  def assert_all_redirect
    assert_redirected_to "/list_item/all"
  end
end
