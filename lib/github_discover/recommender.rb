module GithubDiscover
  class Recommender
    Recommendation = Struct.new(:repo, :score)

    RESULTS_LIMIT = 10

    autoload :MahoutTanimoto, "lib/github_discover/recommender/mahout_tanimoto"

    attr_reader :backend

    def initialize(backend = nil)
      @backend = backend || MahoutTanimoto.new
    end

    def recommend(user)
      ids_with_scores = backend.recommend(user.id, RESULTS_LIMIT)
      repos = Repo.find(ids_with_scores.map(&:first))

      ids_with_scores.map do |id, score|
        repo = repos.find { |r| r.id == id }

        Recommendation.new(repo, score)
      end
    end
  end
end
