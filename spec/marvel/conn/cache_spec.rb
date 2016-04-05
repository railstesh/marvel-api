require "spec_helper"

describe Heroku::Conn::Cache do
  subject { Heroku::Conn::Cache.new }

  describe "#put" do
    let(:new_etag) { "new_etag" }
    let(:old_etag) { "old_etag" }
    let(:r_type)   { "test" }
    let(:json)     { { a: 1 } }
    let(:new_json) { { a: 2 } }

    before do
      subject.put(r_type, old_etag, json)
    end

    it "should update the cache value" do
      subject.put(r_type, new_etag, new_json)
      expect(subject.fetch(r_type, new_etag)).to eq([new_etag, new_json])
    end

    it "should remove references to the old etag." do
      subject.put(r_type, new_etag, new_json)

      expect(subject.fetch(r_type, old_etag)).to be_nil
    end
  end

end
