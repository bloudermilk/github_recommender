module GithubRecommender
  class Repo < ActiveRecord::Base
    has_and_belongs_to_many :starred_by,
      class_name: "GithubRecommender::User",
      join_table: "stars"

    validates :owner, :name, presence: true
  end
end
