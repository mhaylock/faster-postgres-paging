class IndexMoviesOnPrimaryTitleAndId < ActiveRecord::Migration[6.1]
  def change
    add_index :movies, [:primary_title, :id]
  end
end
