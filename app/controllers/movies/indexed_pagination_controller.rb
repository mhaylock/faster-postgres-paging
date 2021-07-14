module Movies
  class IndexedPaginationController < BaseController
    protected

    def movies
      Movie
        .order('start_year DESC NULLS LAST, id ASC')
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
