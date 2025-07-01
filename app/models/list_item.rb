# frozen_string_literal: true

class ListItem < ActiveRecord::Base
  MAX_NAME_LENGTH = 200

  validates :name, presence: true, length: { minimum: 1, maximum: MAX_NAME_LENGTH }
  validates :purchased, inclusion: { in: [true, false] }

  class Error < StandardError; end
  class NotFound < Error; end
  class NameTooLong < Error; end

  class << self
    def mark_purchased(id:)
      item = find_list_item!(id)

      item.update(purchased: true)
      item.save!
    end

    def edit_name(id:, name:)
      validate_name!(name)

      item = find_list_item!(id)

      item.update(name:)
      item.save!
    end

    def add_to_list(name:)
      validate_name!(name)

      item = create(name:, purchased: false)
      item.save!
    end

    def mark_all_as_purchased
      ListItem.update_all(purchased: true)
    end

    def all_by_creation_date
      # Should be by created_at, but did not add the index for that due to time constraints
      ListItem.all.order(id: :desc)
    end

    def delete_list_item(id:)
      find_list_item!(id).destroy
    end

    def delete_all_list_items
      ListItem.destroy_all
    end

    private

    def validate_name!(name)
      raise NameTooLong if name.length > MAX_NAME_LENGTH
    end

    def find_list_item!(id)
      find(id)
    rescue ActiveRecord::RecordNotFound
      raise NotFound
    end
  end
end
