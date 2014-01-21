require "spec_helper"

describe GithubDiscover::JsonStreamParser::Builder do
  let(:json_stream) { '{"foo":"bar"}{"baz":"qux"}' }

  it "parses a stream of JSON objects" do
    objects = []

    on_object = Proc.new do |object|
      objects << object
    end

    subject = described_class.new(on_object)

    subject << json_stream

    expect(objects.length).to eq(2)
    expect(objects[0]).to eq({"foo" => "bar"})
    expect(objects[1]).to eq({"baz" => "qux"})
  end
end
