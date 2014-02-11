require "spec_helper"

describe GithubRecommender::MultiJsonParser do
  describe "#parse!" do
    let(:json_stream) { "{\"foo\":\"bar\"}{\"baz\":\"qux\"}" }

    it "parses a stream of concatenated JSON objects" do
      objects = []

      described_class.new(json_stream) { |o| objects.push(o) }.parse!

      expect(objects).to eq([{"foo" => "bar"}, {"baz" => "qux"}])
    end
  end
end
