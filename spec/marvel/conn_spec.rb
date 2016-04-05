require 'spec_helper'

describe Heroku::Conn do
  describe ".check_response" do
    context "when the response is unsuccessful" do
      let(:unsuccessful_response) { Net::HTTPClientError.new() }

      it "should raise a error" do
        expect { described_class.send(:check_response, nil, nil, response) }.to raise_error
      end
    end
  end

  describe "Parsing" do
    let(:hash) { {"lorem" => "ipsum dolor sit amet"} }
    let(:body) { hash.to_json }
    let(:res)  { double(:res) }

    def set_body(res, body)
      allow(res).to receive(:body).and_return(body)
    end

    def set_encoding(res, enc)
      allow(res).to receive(:[])
        .with("content-encoding")
        .and_return(enc)
    end

    describe ".parse_body" do
      before do
        set_encoding(res, nil)
        set_body(res, body)
      end

      it "attempts to decompress the body" do
        expect(described_class).to receive(:decompress)
          .with(res)
          .and_call_original
        described_class.send(:parse_body, res)
      end

      it "converts the body to json" do
        expect(described_class.send(:parse_body, res)).to eq(hash)
      end
    end

    describe ".decompress" do
      def self.it_returns_the_body
        it "returns the body" do
          expect(described_class.send(:decompress, res)).to eq(body)
        end
      end

      context "when the body is not encoded" do
        before do
          set_encoding(res, "identity")
          set_body(res, body)
        end

        it_returns_the_body
      end

      context "when the body is deflated" do
        before do
          set_encoding(res, "deflate")
          set_body(res, Zlib::Deflate.deflate(body))
        end

        it_returns_the_body
      end

      context "when the body is gzipped" do
        before do
          set_encoding(res, "gzip")

          strio = StringIO.new
          Zlib::GzipWriter.wrap(strio) { |gz| gz.write(body) }
          set_body(res, strio.string)
        end

        it_returns_the_body
      end
    end
  end
end
