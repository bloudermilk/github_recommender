require "spec_helper"

describe GithubRecommender::Recommender do
  subject { described_class.new(stub_backend) }

  before { allow(Repo).to receive(:find).with([repo.id]).and_return(repo) }

  let(:user) { double("GithubRecommender::User", id: 1) }
  let(:repo) { double("GithubRecommender::Repo", id: 2) }
  let(:score) { 0.5 }

  let(:stub_backend) do
    double("stub_backend", recommend: [[repo.id, score]])
  end

  describe "#recommend" do
    it "returns an array of Recommendations" do
      expect(subject.recommend(user)).to eq([
        GithubRecommender::Recommender::Recommendation.new(user, score)
      ])
    end
  end
end
