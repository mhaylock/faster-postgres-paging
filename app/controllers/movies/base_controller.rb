module Movies
  class BaseController < ApplicationController
    helper_method :page, :previous_page_path, :next_page_path, :next_benchmark_path

    def index
      start = Time.now
      @movies = load_movies
      @query_time = Time.now - start

      benchmark_results = Rails.cache.read(benchmark_key) || {}
      benchmark_results[page] = @query_time
      Rails.cache.write(benchmark_key, benchmark_results)
    end

    protected

    def benchmark_key
      raise NotImplementedError
    end

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
      @benchmark_direction ||= begin
        existing_direction = params[:benchmark_direction]

        if existing_direction.blank? || (existing_direction == 'down' && page == 1)
          nil
        else
          existing_direction
        end
      end
    end

    def next_benchmark_path
      @next_benchmark_path ||= begin
        case benchmark_direction
        when 'up'
          next_page_path
        when 'down'
          previous_page_path
        end
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
