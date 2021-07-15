module Movies
  class BenchmarksController < BaseController
    helper_method :benchmark_start_urls

    def show
      Rails.cache.clear
    end

    def data
      render json: [
        {
          name: 'Offset Unindexed',
          data: Rails.cache.read('unindexed').to_a.sort
        },
        {
          name: 'Offset Indexed',
          data: Rails.cache.read('indexed').to_a.sort
        },
        {
          name: 'Seek / Keyset',
          data: Rails.cache.read('seek').to_a.sort
        }
      ]
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
