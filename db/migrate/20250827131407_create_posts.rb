class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string  :title,          null: false, default: ""
      t.text    :body,           null: false, default: ""
      t.integer :genre,          null: false, index: true, default: "0"
      t.integer :kind,           null: false, index: true, default: "0"
      t.integer :origin_country, null: false, index: true, default: "0"
      t.integer :place,          null: false, index: true, default: "0"
      t.timestamps
    end
  end
end
