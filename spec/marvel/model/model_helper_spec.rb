require 'spec_helper'

describe Heroku::Model::ModelHelper do
  let(:_Model) do
    Class.new(Struct.new(:a, :b, :c)) do
      include Heroku::Model::ModelHelper
    end
  end

  subject { _Model[1, 2, 3] }


  describe "#struct_init_from_hash" do
    let(:valid_hash)     { { "a" => 1, "b" => 2, "c" => 3 } }
    let(:disorderd_hash) { { "b" => 2, "a" => 1, "c" => 3 }}
    let(:invalid_hash)   { { "d" => 4 } }

    it "finds all the values from the hash that are members of the Model." do
      init_list = subject.struct_init_from_hash(valid_hash)
      expect(init_list).to match_array([1, 2, 3])
    end

    it "provides the values in the Model's order, not the hash's." do
      init_list = subject.struct_init_from_hash(disorderd_hash)
      expect(init_list).to eq([1, 2, 3])
    end

    it "ignores values from the has that are not members of the Model." do
      init_list = subject.struct_init_from_hash(invalid_hash)
      expect(init_list).not_to include(4)
    end
  end

  describe "#sub_struct_as_hash" do
    let(:valid_params) { [:a, :b] }
    let(:invalid_params) { [:d] }

    it "returns a hash of the requisite parameters." do
      hash = subject.sub_struct_as_hash(*valid_params)
      expect(hash).to include(a: 1, b: 2)
    end

    it "does not include paramters that are not requested." do
      hash = subject.sub_struct_as_hash(*valid_params)
      expect(hash).not_to include(:c)
    end

    it "ignores parameters that do not exist." do
      hash = subject.sub_struct_as_hash(*invalid_params)
      expect(hash).not_to include(:d)
    end
  end

  describe "#identifier" do
    context "when there are no identifiable parameters" do
      before do
        expect(subject).to receive(:identifiable).and_return({})
      end

      it "should return an empty identifier" do
        expect(subject.identifier).to be_empty
      end
    end

    context "when the identifier is one parameter" do
      before do
        expect(subject).to receive(:identifiable).and_return({ a: 1 })
      end

      it "should appear in the identifier" do
        expect(subject.identifier).to eq "a=1"
      end
    end

    context "when the identifier contains multiple parameters" do
      before do
        expect(subject).to receive(:identifiable).and_return({ a: 1, b: 2})
      end

      it "should return a comma separated list" do
        expect(subject.identifier).to eq "a=1, b=2"
      end
    end
  end
end
