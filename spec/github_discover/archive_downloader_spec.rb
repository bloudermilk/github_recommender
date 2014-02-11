require "spec_helper"
require "fakefs/spec_helpers"

describe GithubRecommender::ArchiveDownloader do
  include FakeFS::SpecHelpers

  describe "#get" do
    let(:time) { Time.new(2013, 1, 16) }

    let!(:response) do
      FakeFS.without do
        File.read("spec/fixtures/data.githubarchive.org/2013-01-16-0.json.gz")
      end
    end

    before do
      stub_request(:get, "http://data.githubarchive.org/2013-01-16-0.json.gz").to_return(body: response)
    end

    it "downloads the right file for `time`" do
      the_path = nil

      callback = proc do |path|
        the_path = path
      end

      subject.get(time, callback)
      expect(File.read(the_path)).to eq(response)
    end
  end
end
