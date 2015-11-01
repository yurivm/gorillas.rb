require "spec_helper"

describe Gorillas::Sprite do
  let(:coordinates) { Gorillas::Coordinates.new(50, 100) }
  subject { described_class.new(coordinates)}

  describe "#initialize" do
    it "clones the coordinates object" do
      expect(subject.coordinates.object_id).to_not eq(coordinates.object_id)
    end
  end

  describe "#x" do
    it "returns the X coordinate" do
      expect(subject.x).to eq(coordinates.x)
    end
  end

  describe "#y" do
    it "returns the Y coordinate" do
      expect(subject.y).to eq(coordinates.y)
    end
  end
end
