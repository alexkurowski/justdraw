class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :fname
      t.string :author
      t.string :parent
      t.boolean :public

      t.timestamps
    end
  end
end
