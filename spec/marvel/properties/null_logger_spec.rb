require 'spec_helper'

describe Heroku::Properties::NullLogger do

  subject { described_class.new }

  it { should respond_to(:unknown).with(1).argument }
  it { should respond_to(:warn).with(1).argument }
  it { should respond_to(:debug).with(1).argument }
  it { should respond_to(:info).with(1).argument }

  describe "#tagged" do
    let(:block_check) { double("block_check", call: true) }

    it { should respond_to(:tagged).with(1).argument }
    it "calls the block provided to it" do
      expect(block_check).to receive(:call).once

      subject.tagged("tag") do
        block_check.call
      end
    end
  end

end
