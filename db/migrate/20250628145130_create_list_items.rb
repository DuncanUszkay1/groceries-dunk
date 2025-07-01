# frozen_string_literal: true

class CreateListItems < ActiveRecord::Migration[7.1]
  def change
    create_table :list_items do |t|
      t.string :name
      t.boolean :purchased

      t.timestamps
    end
  end
end
