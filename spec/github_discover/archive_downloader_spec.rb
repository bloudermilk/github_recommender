require "spec_helper"

describe GithubDiscover::ArchiveDownloader do
  describe "#get" do
    let(:time) { Time.new(2013, 1, 16) }
    let(:io_out) { StringIO.new }
    let(:response) { File.new("spec/fixtures/data.githubarchive.org/2013-01-16-0.json.gz") }

    before do
      stub_request(:get, "http://data.githubarchive.org/2013-01-16-0.json.gz").to_return(body: response)
    end

    it "fetches the proper file for `time` and prints the response to `io_out`" do
      subject.get(time, io_out)

      expect(io_out).to eq(response.read)
    end
  end
end
