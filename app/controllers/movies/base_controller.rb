module Movies
  class BaseController < ApplicationController
    helper_method :page, :previous_page_path, :next_page_path,
      :benchmark_direction, :next_benchmark_path

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
      {
        page: page - 1,
        per_page: per_page,
        benchmark_direction: benchmark_direction
      }.compact
    end

    def previous_page_path
      raise NotImplementedError
    end

    def next_page_params
      {
        page: page + 1,
        per_page: per_page,
        benchmark_direction: benchmark_direction
      }.compact
    end

    def next_page_path
      raise NotImplementedError
    end

    def benchmark_direction
      existing_direction = params[:benchmark_direction]

      return if existing_direction.blank?
      return if existing_direction == 'down' && page == 1

      return 'down' if existing_direction == 'up' && page == 200
      existing_direction
    end

    def next_benchmark_path
      @next_benchmark_path ||=
        case benchmark_direction
        when 'up'
          next_page_path
        when 'down'
          previous_page_path
        end
    end

    def page
      (params[:page] || '1').to_i
    end

    def per_page
      (params[:per_page] || '500').to_i
    end
  end
end
