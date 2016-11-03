class AddUserReferencesToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :user, foreign_key: true, index: true
  end
end
