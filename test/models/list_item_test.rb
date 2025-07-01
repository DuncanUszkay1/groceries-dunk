# frozen_string_literal: true

require 'test_helper'

class ListItemTest < ActiveSupport::TestCase
  test '#add_to_list creates an unpurchased list item with the correct name' do
    item_name = 'bananas'

    assert_difference 'ListItem.count', 1 do
      ListItem.add_to_list(name: item_name)
    end

    assert_equal item_name, ListItem.last.name
    refute ListItem.last.purchased
  end

  test '#add_to_list allows duplicate entries' do
    item_name = 'bananas'

    assert_difference 'ListItem.count', 2 do
      ListItem.add_to_list(name: item_name)
      ListItem.add_to_list(name: item_name)
    end
  end

  test '#add_to_list returns an error when the name is too long' do
    assert_raises ListItem::NameTooLong do
      ListItem.add_to_list(name: 'a' * (ListItem::MAX_NAME_LENGTH + 1))
    end
  end

  test '#edit_name returns an error when the name is too long' do
    assert_raises ListItem::NameTooLong do
      ListItem.edit_name(id: list_items(:unpurchased_potato).id, name: 'a' * (ListItem::MAX_NAME_LENGTH + 1))
    end
  end

  test '#mark_purchased changes the purchased boolean on the record from false to true' do
    unpurchased_item = list_items(:unpurchased_potato)

    refute unpurchased_item.purchased

    ListItem.mark_purchased(id: unpurchased_item.id)

    assert ListItem.find(unpurchased_item.id).purchased
  end

  test '#mark_purchased no-ops on purchased items' do
    purchased_item = list_items(:purchased_jar)

    assert purchased_item.purchased

    ListItem.mark_purchased(id: purchased_item.id)

    assert ListItem.find(purchased_item.id)
  end

  test '#edit_name updates the name of the corresponding record' do
    item = list_items(:unpurchased_potato)
    new_name = 'yam'

    ListItem.edit_name(id: item.id, name: new_name)

    assert_equal new_name, ListItem.find(item.id).name
  end

  test '#edit_name raises a RecordNotFound error when an unknown ID is passed in' do
    random_id = 1_209_302_930

    assert_raises ListItem::NotFound do
      ListItem.edit_name(id: random_id, name: 'odjsod')
    end
  end

  test '#mark_purchased raises a ListItemNotFound error when an unknown ID is passed in' do
    random_id = 1_209_302_930

    assert_raises ListItem::NotFound do
      ListItem.mark_purchased(id: random_id)
    end
  end

  test '#mark_all_as_purchased marks all records as purchased' do
    refute_equal 0, ListItem.where(purchased: false).count

    ListItem.mark_all_as_purchased

    assert_equal 0, ListItem.where(purchased: false).count
  end
end
