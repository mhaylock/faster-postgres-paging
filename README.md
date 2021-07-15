# Faster Postgres Pagination Demonstration

This is a scrappy example Rails application that demonstrates how "Seek Method"
Pagination (also known as "Keyset Pagination") is faster than OFFSET based
pagination.

## Setup

Requires Ruby 3.0.2. Install dependencies using `bundle install`, then setup
database with:
```
$ bin/rails db:create db:schema:load db:seed
```
This will download the IMDB titles database using `bin/download_database` and
populate the `movies` table with movies from that database file.

## Running

To start:
```
bin/rails server
```

The relevant paths (assuming server is running on port 3000):
* [Unindexed OFFSET Pagination](http://localhost:3000/movies/unindexed)
* [Indexed OFFSET Pagination](http://localhost:3000/movies/indexed)
* [Seek / Keyset Pagination](http://localhost:3000/movies/seek)
* [Benchmarking All Three](http://localhost:3000/movies/benchmark)

## Notes

Benchmarking is accomplished by measuring the time it takes for the Movies to
be loaded into memory by ActiveRecord, so the times are not a direct benchmark
of Postgres but also include ActiveRecord and some other Ruby processing time.

Times are captured in the Rails MemoryStore cache, which is a complete hack and
only appropriate for the demonstration purposes used here 😜

## References

* [Five ways to paginate in Postgres, from the basic to the exotic](https://www.citusdata.com/blog/2016/03/30/five-ways-to-paginate/)
* [Pagination done the Right way](https://www.slideshare.net/MarkusWinand/p2d2-pagination-done-the-postgresql-way)
* [Paging Through Results](https://use-the-index-luke.com/sql/partial-results/fetch-next-page)
* (Untested) [order_query](https://github.com/glebm/order_query) gem for adding keyset pagination support to ActiveRecord.
