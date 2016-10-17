class CreateAsset < ActiveRecord::Migration[5.0]
  def change
    create_table :assets do |t|
      t.string :title, null: false
      t.string :file
    end
  end
end


class CreateMediators < ActiveRecord::Migration[5.0]
  def change
    create_table :mediators do |t|
      t.timestamps null: false
      t.jsonb :data, null: false
    end
  end
end
