require "spec_helper"

describe Gorillas::House do
  let(:coordinates) { Gorillas::Coordinates.new(80, 120) }
  let(:params) do
    {
      coordinates: coordinates,
      width: 100,
      height: 220,
      color: "Rusty"
    }
  end

  subject { described_class.new(params) }

  describe "#x2" do
    it "returns the right border of the house (X + width)" do
      expect(subject.x2).to eq(80 + 100)
    end
  end

  describe "#bounding_box" do
    let(:bounding_box) { subject.bounding_box }
    it "returns a bounding box for the house" do
      expect(bounding_box).to be_a(Gorillas::BoundingBox)
    end
    it "returns a bounding box with width margin" do
      expect(bounding_box.x1).to eq(subject.x)
      expect(bounding_box.y1).to eq(subject.y)
      expect(bounding_box.x2).to eq(subject.x2 - described_class::HOUSE_MARGIN)
    end

    it "returns a bounding box with y2 = window height" do
      expect(bounding_box.y2).to eq(Gorillas::GameWindow::SCREEN_HEIGHT)
    end
  end
end
