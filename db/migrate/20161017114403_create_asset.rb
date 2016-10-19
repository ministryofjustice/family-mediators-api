class CreateAsset < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.string :title, null: false
      t.string :file
    end
  end
end