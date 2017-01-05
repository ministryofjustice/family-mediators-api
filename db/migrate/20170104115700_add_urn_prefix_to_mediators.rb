class AddUrnPrefixToMediators < ActiveRecord::Migration[5.0]
  def change
    add_column :mediators, :urn_prefix, :integer
    add_index :mediators, :urn_prefix, unique: true
  end
end
