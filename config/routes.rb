Rails.application.routes.draw do
  get '/', to: redirect('/movies')

  scope 'movies', module: 'movies', as: 'movies' do
    get '/', to: redirect('/movies/seek')

    get 'unindexed', action: :index, controller: 'unindexed_pagination'
    get 'indexed', action: :index, controller: 'indexed_pagination'
    get 'seek', action: :index, controller: 'seek_pagination'

    resource 'benchmark', only: [:show]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
