module Movies
  class SeekPaginationController < BaseController
    protected

    def benchmark_key
      :seek
    end

    def movies
      if before_movie.present?
        movies_before
      else
        movies_after
      end
    end

    def load_movies
      movies = super
      # When using `before` for pagination, order must be reversed from what is
      # received from Postgres:
      before_movie.present? ? movies.reverse : movies
    end

    def previous_page_path
      return unless page > 1
      movies_seek_path(**previous_page_params, before: @movies.first.id)
    end

    def next_page_path
      # There won't be a next page if the current page isn't a full page:
      return unless @movies.length == per_page
      movies_seek_path(**next_page_params, after: @movies.last.id)
    end

    private

    def before_movie
      @before_movie ||= Movie.find(params[:before]) if params[:before].present?
    end

    def movies_before
      Movie
        .where('start_year >= ?', before_movie.start_year)
        .where.not(
          'start_year = ? AND id >= ?',
          before_movie.start_year,
          before_movie.id
        )
        .order('start_year ASC NULLS FIRST, id DESC')
        .limit(per_page)
    end

    def after_movie
      @after_movie ||= Movie.find(params[:after]) if params[:after].present?
    end

    def movies_after
      movies = Movie
        .order('start_year DESC NULLS LAST, id ASC')
        .limit(per_page)

      if after_movie.present?
        movies = movies
          .where('start_year <= ?', after_movie.start_year)
          .where.not(
            'start_year = ? AND id <= ?',
            after_movie.start_year,
            after_movie.id
          )
      end

      movies
    end
  end
end
