require 'spec_helper'

describe Marvel::Properties do

  it "should respond to #auth_token" do
    expect(described_class).to respond_to(:auth_token)
  end

  describe "#api_key=" do
    let(:api_key) { "01234567-89ab-cdef-0123-456789abcdef" }

    it "should create a base64 encoded auth token" do
      described_class.api_key = api_key
      expect(described_class.auth_token).to eq(Base64.encode64(":#{api_key}\n").strip)
    end

    context "when no api_key is provided" do
      let(:api_key) { nil }

      it "should raise an error" do
        expect { described_class.api_key = api_key }.to raise_error(ArgumentError)
      end

      it "should leave the auth_token unchanged" do
        expect {
          begin
            described_class.api_key = api_key
          rescue ArgumentError
          end
        }.not_to change(described_class, :auth_token)
      end
    end
  end

  context "when no logger is provided" do
    before do
      described_class.logger = nil
    end

    it "should provide a null logger" do
      expect(described_class.logger).not_to be_nil
    end
  end

end
