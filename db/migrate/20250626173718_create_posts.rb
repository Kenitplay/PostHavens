class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.string :status
      t.datetime :scheduled_at

      t.timestamps
    end
  end
end
