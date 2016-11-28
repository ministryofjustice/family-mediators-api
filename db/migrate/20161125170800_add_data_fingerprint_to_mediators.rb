class AddDataFingerprintToMediators < ActiveRecord::Migration[5.0]
  def up
     add_column :mediators, :data_fingerprint, :string, null: false
  end

  def down
    remove_column :mediators, :data_fingerprint
  end
end
