module Movies
  class IndexedPaginationController < BaseController
    protected

    def benchmark_key
      :indexed
    end

    def movies
      Movie
        .order('primary_title ASC, id ASC')
        .limit(per_page)
        .offset(offset)
    end

    def previous_page_path
      movies_indexed_path(**previous_page_params) if page > 1
    end

    def next_page_path
      movies_indexed_path(**next_page_params) if movies.length == per_page
    end

    private

    def offset
      (page - 1) * per_page
    end
  end
end
