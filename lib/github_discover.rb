$LOAD_PATH.push(File.expand_path("../../lib", __FILE__))

require "commons-dbcp-1.4.jar"
require "mahout-core-0.8.jar"

module GithubDiscover
  autoload :ArchiveDownloader, "github_discover/archive_downloader"
  autoload :ArchiveProcessor, "github_discover/archive_processor"
  autoload :EventMapper, "github_discover/event_mapper"
  autoload :MultiJsonParser, "github_discover/multi_json_parser"
  autoload :Recommender, "github_discover/recommender"
  autoload :Repo, "github_discover/repo"
  autoload :Scraper, "github_discover/scraper"
  autoload :Star, "github_discover/star"
  autoload :User, "github_discover/user"

  def self.connect_db!
    @db_connection = ActiveRecord::Base.establish_connection(ENV["GHD_DB_URL"])
  end

  def self.jdbc_connection
    if @db_connection
      # FIXME: This can't be necessary...
     ActiveRecord::Base.connection.instance_variable_get(:@connection).instance_variable_get(:@connection)
    else
      raise "Need to GithubDiscover.connect_db! before accessing the DB, yo!"
    end
  end
end
