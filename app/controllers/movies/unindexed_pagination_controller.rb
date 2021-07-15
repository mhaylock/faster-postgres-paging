module Movies
  class UnindexedPaginationController < IndexedPaginationController

    def index
      ActiveRecord::Base.transaction do
        # Disable index for length of transaction:
        ActiveRecord::Base.connection.execute <<~SQL
          UPDATE pg_index
          SET indisvalid = false
          WHERE indexrelid = 'index_movies_on_start_year_and_id'::regclass
        SQL

        super

        # Rollback index being disabled:
        raise ActiveRecord::Rollback
      end
    end

    protected

    def benchmark_key
      :unindexed
    end

    def previous_page_path
      movies_unindexed_path(**previous_page_params) if page > 1
    end

    def next_page_path
      movies_unindexed_path(**next_page_params) if @movies.length == per_page
    end
  end
end
