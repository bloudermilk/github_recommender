module GithubDiscover
  class User < ActiveRecord::Base
    has_and_belongs_to_many :starred_repos,
      class_name: "GithubDiscover::Repo",
      join_table: "stars"
  end
end
