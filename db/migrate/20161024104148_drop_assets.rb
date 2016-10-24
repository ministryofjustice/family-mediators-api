class DropAssets < ActiveRecord::Migration[5.0]
  def change
    drop_table :assets
  end
end
