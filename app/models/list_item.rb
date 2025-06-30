class ListItem < ActiveRecord::Base 
    MAX_NAME_LENGTH = 200

    validates :name, presence: true, length: { minimum: 1, maximum: MAX_NAME_LENGTH }
    validates :purchased, inclusion: { in: [true, false] } 

    class Error < StandardError; end;
    class NotFound < Error 
        def initialize(id)
            @id = id
            super
        end

        def message
            "Could not find List Item with ID #{@id}"
        end
    end
    class NameTooLong < Error 
        def initialize(name)
            @name_fragment = name[0, MAX_NAME_LENGTH]
        end

        def message
            "Name starting with #{@name_fragment}... is too long. The maximum is 200 characters."
        end
    end

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

        def delete(id:)
            item = find_list_item!(id)
            
            item.delete
        end

        def mark_all_as_purchased
            ListItem.update_all(purchased: true)
        end

        private

        def validate_name!(name)
            raise NameTooLong.new(name) if name.length > MAX_NAME_LENGTH 
        end

        def find_list_item!(id)
            find(id)
        rescue ActiveRecord::RecordNotFound
            raise NotFound.new(id)
        end
    end
end
