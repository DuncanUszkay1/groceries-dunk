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
            item.update(name: true)
            item.save!
        end

        def add_to_list(name:) 
            item = create(name:, purchased: false)
            item.save!
        end
    end
end
