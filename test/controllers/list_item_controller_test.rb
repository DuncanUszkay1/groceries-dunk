require "test_helper"

class ListItemControllerTest < ActionDispatch::IntegrationTest
  setup do
    @purchased_item = list_items(:purchased_jar)
    @unpurchased_item = list_items(:unpurchased_potato)
  end

  test "post to add_to_list with a valid name should create and redirect to all" do
    item_name = "yam"
    post list_item_add_to_list_url, params: { name: item_name }
    assert_equal item_name, ListItem.last.name
    assert_redirected_to "/list_item/all"
  end

  test "post to mark_purchased with a valid ID for a purchased or unpurchased item should mark as purchased and redirect to all" do
    refute ListItem.find(@unpurchased_item.id).purchased
    assert ListItem.find(@purchased_item.id).purchased

    post list_item_mark_purchased_url, params: { id: @unpurchased_item.id }
    assert_redirected_to "/list_item/all"
    assert ListItem.find(@unpurchased_item.id).purchased

    post list_item_mark_purchased_url, params: { id: @purchased_item.id }
    assert_redirected_to "/list_item/all"
    assert ListItem.find(@purchased_item.id).purchased
  end

  test "post to edit name with a valid name should edit the name and redirect to all" do
    item_name = "yam"
    refute_equal item_name, ListItem.find(@unpurchased_item.id).name 

    post list_item_edit_name_url, params: { id: @unpurchased_item.id, name: item_name }

    assert_equal item_name, ListItem.find(@unpurchased_item.id).name 
    assert_redirected_to "/list_item/all"
  end

  test "get to all returns a 200" do
    get list_item_all_url

    assert_response :success
  end

  test "delete_all should delete all list items and redirect to all" do
    refute_equal 0, ListItem.count

    post list_item_delete_all_url
    assert_redirected_to "/list_item/all"

    assert_equal 0, ListItem.count
  end

  test "mark_all_as_purchased should mark all as purchased and redirect to all" do
    refute_equal 0, ListItem.where(purchased: false).count

    post list_item_mark_all_as_purchased_url
    assert_redirected_to "/list_item/all"

    assert_equal 0, ListItem.where(purchased: false).count
    refute_equal 0, ListItem.where(purchased: true).count
  end
end
