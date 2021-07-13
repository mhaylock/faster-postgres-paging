class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :imdb_title_id
      t.string :primary_title, null: false
      t.string :original_title, null: false
      t.integer :start_year
      t.integer :end_year
      t.integer :runtime_minutes
      t.string :genres, array: true

      t.timestamps
    end
  end
end
