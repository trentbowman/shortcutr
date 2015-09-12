class CreateShortcuts < ActiveRecord::Migration
  def change
    create_table :shortcuts do |t|
      t.string :url
      t.string :target

      t.timestamps null: false
    end
  end
end
