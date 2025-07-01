# frozen_string_literal: true

require 'application_system_test_case'

class ListItemsTest < ApplicationSystemTestCase
  setup do
    visit list_item_all_url

    @starting_items = ListItem.all

    assert page_has_list_items?(@starting_items)
  end

  test 'user adds new item by typing into autofocused field' do
    new_item_name = 'yam'

    send_keys(*new_item_name, :enter)

    assert page_has_list_item_with_name?(new_item_name)
  end

  test 'user deletes the first item' do
    item_to_delete = @starting_items.first

    click_button(id: delete_button_id(item_to_delete.id))

    refute page_has_list_item_with_name?(item_to_delete.name)
  end

  test 'user deletes all items' do
    click_button(id: delete_all_id)

    @starting_items.each do |item|
      refute page_has_list_item_with_name?(item.name)
    end
  end

  test 'user marks an unpurchased item as purchased' do
    item_to_purchase = @starting_items.find { |item| !item.purchased }

    click_button(id: purchase_button_id(item_to_purchase.id))

    refute page_has_purchase_button_for_item_id?(item_to_purchase.id)
  end

  test 'user marks all unpurchased items as purchased' do
    click_button(id: purchase_all_id)

    @starting_items.each do |item|
      refute page_has_purchase_button_for_item_id?(item.id)
    end
  end

  test 'user receives error message when entering an item name that is too long' do
    new_item_name = 'a' * (ListItem::MAX_NAME_LENGTH + 1)

    send_keys(*new_item_name, :enter)

    assert page.has_text?(ListItemController::NAME_TOO_LONG_MESSAGE)
  end

  private

  def page_has_list_items?(list_items)
    list_items.all? do |item|
      page_has_list_item_with_name?(item.name)
    end
  end

  def page_has_list_item_with_name?(name)
    page.has_field?('name', with: name)
  end

  def page_has_purchase_button_for_item_id?(id)
    page.has_button?(id: purchase_button_id(id))
  end

  def delete_button_id(id)
    "delete-#{id}"
  end

  def purchase_button_id(id)
    "purchase-#{id}"
  end

  def delete_all_id
    'delete-all'
  end

  def purchase_all_id
    'purchase-all'
  end
end
