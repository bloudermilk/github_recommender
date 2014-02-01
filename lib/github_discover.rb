$LOAD_PATH.push(File.expand_path("../../lib", __FILE__))

module GithubDiscover
  autoload :ArchiveDownloader, "github_discover/archive_downloader"
  autoload :ArchiveProcessor, "github_discover/archive_downloader"
  autoload :EventMapper, "github_discover/event_mapper"
  autoload :MultiJsonParser, "github_discover/multi_json_parser"
  autoload :Repo, "github_discover/repo"
  autoload :Scraper, "github_discover/scraper"
  autoload :Star, "github_discover/star"
  autoload :User, "github_discover/user"
end
