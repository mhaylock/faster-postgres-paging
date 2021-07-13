class AddStartYearIndexToMovies < ActiveRecord::Migration[6.1]
  def change
    add_index :movies, [:start_year, :id],
      order: { start_year: 'DESC NULLS LAST', id: :asc }
  end
end
