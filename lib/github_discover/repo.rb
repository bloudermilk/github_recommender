module GithubDiscover
  class Repo < ActiveRecord::Base
    has_and_belongs_to_many :starred_by,
      class_name: "GithubDiscover::User",
      join_table: "stars"
  end
end
