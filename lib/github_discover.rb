$LOAD_PATH.push(File.expand_path("../../lib", __FILE__))

module GithubDiscover
  autoload :API, "github_discover/api"
  autoload :ArchiveDownloader, "github_discover/archive_downloader"
  autoload :ArchiveProcessor, "github_discover/archive_processor"
  autoload :EventMapper, "github_discover/event_mapper"
  autoload :MultiJsonParser, "github_discover/multi_json_parser"
  autoload :Recommender, "github_discover/recommender"
  autoload :Repo, "github_discover/repo"
  autoload :Scraper, "github_discover/scraper"
  autoload :User, "github_discover/user"

  def self.connect_db!
    @db_connection = ActiveRecord::Base.establish_connection(ENV["GHD_DB_URL"])
  end

  def self.recommender
    @recommender ||= Recommender.new
  end
end
