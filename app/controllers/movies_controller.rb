class MoviesController < ApplicationController
  helper_method :previous_page_path, :next_page_path

  def index
    @movies = Movie
      .order('start_year DESC NULLS LAST, id ASC')
      .limit(per_page)
      .offset(offset)

    start = Time.now
    @movies.load
    @query_time = Time.now - start
  end

  protected

  def previous_page_path
    movies_path(page: page - 1, per_page: per_page) if page > 1
  end

  def next_page_path
    movies_path(page: page + 1, per_page: per_page)
  end

  private

  def page
    (params[:page] || '1').to_i
  end

  def offset
    (page - 1) * per_page
  end

  def per_page
    (params[:per_page] || '500').to_i
  end
end
