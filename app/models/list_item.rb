class ListItem < ActiveRecord::Base 
    validates :name, presence: true, length: { minimum: 1, maximum: 200 }
    validates :purchased, inclusion: { in: [true, false] } 

    class << self
        def mark_purchased(id:)
            item = find(id)
            item.update(purchased: true)
            item.save!
        end

        def edit_name(id:, name:) 
            item = find(id)
            item.update(name:)
            item.save!
        end

        def add_to_list(name:) 
            item = create(name:, purchased: false)
            item.save!
        end

        def delete(id:)
            find(id).delete
        end

        def mark_all_as_purchased
            ListItem.update_all(purchased: true)
        end
    end
end
