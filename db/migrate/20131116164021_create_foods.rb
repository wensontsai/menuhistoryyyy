class CreateFoods < ActiveRecord::Migration
  def change
    create_table :foods do |t|
      t.string :dish
      t.integer :year
      t.integer :qty

      t.timestamps
    end
  end
end
