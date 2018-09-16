class AddCreatedByToShops < ActiveRecord::Migration[5.2]
  def change
    add_column :shops, :created_by, :string
  end
end
