class AddCategoriesToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :category, foreign_key: true, index: true
  end
end
