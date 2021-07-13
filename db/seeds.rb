require 'pathname'

puts "Downloading IMDB database..."
system(File.expand_path("#{__dir__}/../bin/download_database"), exception: true)

imdb_database_file = Pathname("#{__dir__}/../tmp/title.basics.tsv").expand_path

puts "Populating database..."
ActiveRecord::Base.transaction do
  connection = ActiveRecord::Base.connection
  raw_connection = connection.raw_connection

  connection.execute <<~SQL
    TRUNCATE movies;

    CREATE TEMP TABLE imported_imdb_titles (
      tconst varchar,
      titleType varchar,
      primaryTitle varchar,
      originalTitle varchar,
      isAdult boolean,
      startYear integer,
      endYear integer,
      runtimeMinutes integer,
      genres varchar
    );
  SQL

  raw_connection.copy_data(<<~SQL) do
    COPY imported_imdb_titles
    FROM STDIN
    WITH (FORMAT CSV, HEADER, DELIMITER '\t', NULL '\\N', QUOTE '|');
  SQL
    imdb_database_file.each_line do |line|
      raw_connection.put_copy_data(line)
    end
  end

  connection.execute <<~SQL
    INSERT INTO movies (
      imdb_title_id,
      primary_title,
      original_title,
      start_year,
      end_year,
      runtime_minutes,
      genres,
      created_at,
      updated_at
    )
    SELECT
      tconst,
      primaryTitle,
      originalTitle,
      startYear,
      endYear,
      runtimeMinutes,
      string_to_array(genres, ','),
      NOW(),
      NOW()
    FROM imported_imdb_titles
    WHERE isAdult = false AND titleType = 'movie';
  SQL
end
