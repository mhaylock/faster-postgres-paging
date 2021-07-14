module Movies
  class BaseController < ApplicationController
    helper_method :previous_page_path, :next_page_path

    def index
      start = Time.now
      @movies = load_movies
      @query_time = Time.now - start
    end

    protected

    def movies
      raise NotImplementedError
    end

    def load_movies
      movies.load
    end

    def previous_page_params
      { page: page - 1, per_page: per_page }
    end

    def previous_page_path
      raise NotImplementedError
    end

    def next_page_params
      { page: page + 1, per_page: per_page }
    end

    def next_page_path
      raise NotImplementedError
    end

    def page
      (params[:page] || '1').to_i
    end

    def per_page
      (params[:per_page] || '500').to_i
    end
  end
end
