module GithubRecommender
  class User < ActiveRecord::Base
    has_and_belongs_to_many :starred_repos,
      class_name: "GithubRecommender::Repo",
      join_table: "stars"

    validates :login, presence: true
  end
end
