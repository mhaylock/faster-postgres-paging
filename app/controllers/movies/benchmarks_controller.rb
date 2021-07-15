module Movies
  class BenchmarksController < BaseController
    helper_method :benchmark_start_urls

    def show
    end

    protected

    def benchmark_start_paths
      @benchmark_start_paths ||= {
        indexed: movies_benchmark_path()
      }
    end

    def per_page
      (params[:per_page] || '500').to_i
    end
  end
end
