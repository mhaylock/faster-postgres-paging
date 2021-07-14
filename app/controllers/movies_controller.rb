class MoviesController < ApplicationController
  helper_method :previous_page_path, :next_page_path

  def index
    movies = Movie
      .order('start_year DESC NULLS LAST, id ASC')
      .limit(per_page)

    if params[:before].present?
      before_movie = Movie.find(params[:before])
      movies = movies.reorder('start_year ASC NULLS FIRST, id DESC')
      movies = movies
        .where('start_year >= ?', before_movie.start_year)
        .where.not(
          'start_year = ? AND id >= ?',
          before_movie.start_year, before_movie.id
        )
    elsif params[:after].present?
      after_movie = Movie.find(params[:after])
      movies = movies
        .where('start_year <= ?', after_movie.start_year)
        .where.not(
          'start_year = ? AND id <= ?',
          after_movie.start_year, after_movie.id
        )
    end

    start = Time.now
    movies.load
    @query_time = Time.now - start

    @movies = params[:before].present? ? movies.to_a.reverse : movies
  end

  protected

  def previous_page_path
    movies_path(before: before)
  end

  def next_page_path
    movies_path(after: after)
  end

  private

  def page
    @page ||= (params[:page] || '1').to_i
  end

  def before
    @movies.to_a.first.id
  end

  def after
    @movies.to_a.last.id unless @movies.length < per_page
  end

  def per_page
    @per_page ||= (params[:per_page] || '500').to_i
  end
end
