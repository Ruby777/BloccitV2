class CreateAdvertisements < ActiveRecord::Migration[5.2]
  def change
    create_table :advertisements do |t|
      t.string :title
      t.string :copy
      t.integer :price

      t.timestamps
    end
  end
end
