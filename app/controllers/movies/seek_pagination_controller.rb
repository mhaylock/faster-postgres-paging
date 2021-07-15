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
        .where('(primary_title, id) < (?, ?)', before_movie.primary_title, before_movie.id)
        .order('primary_title DESC, id DESC')
        .limit(per_page)
    end

    def after_movie
      @after_movie ||= Movie.find(params[:after]) if params[:after].present?
    end

    def movies_after
      movies = Movie
        .order('primary_title ASC, id ASC')
        .limit(per_page)

      if after_movie.present?
        movies = movies
          .where('(primary_title, id) > (?, ?)', after_movie.primary_title, after_movie.id)
      end

      movies
    end
  end
end
