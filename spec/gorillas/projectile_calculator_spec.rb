require "spec_helper"

describe Gorillas::ProjectileCalculator do
  def degrees(rad)
    Gosu.radians_to_degrees(rad)
  end

  let(:gorilla_coordinates) { Gorillas::Coordinates.new(100, 200) }
  let(:mouse_coordinates) { Gorillas::Coordinates.new(200, 250) }
  let(:offset) { 100 }

  subject { described_class.new }

  describe "#calculate_params" do
    before do
      subject.set_values(gorilla_coordinates, mouse_coordinates)
      subject.calculate_params
    end
    context "when the aim is horizontal" do
      let(:mouse_coordinates) do
        Gorillas::Coordinates.new(gorilla_coordinates.x + offset, gorilla_coordinates.y)
      end
      it "returns zero angle" do
        expect(subject.angle).to eq(0)
      end
      it "returns horizontal speed only" do
        expect(subject.velocity.x).to eq(offset)
        expect(subject.velocity.y).to eq(0)
      end
      it "lands offscreen" do
        expect(subject.lands_offscreen?).to be(true)
      end
    end

    context "when the aim is vertical" do
      let(:mouse_coordinates) do
        Gorillas::Coordinates.new(gorilla_coordinates.x, gorilla_coordinates.y + offset)
      end
      it "returns a 90 deg angle" do
        expect(degrees(subject.angle)).to be_within(0.01).of(90)
      end
      it "returns vertical speed only" do
        expect(subject.velocity.x).to eq(0)
        expect(subject.velocity.y).to eq(offset)
      end
      it "does not land offscreen" do
        expect(subject.lands_offscreen?).to be(false)
      end
    end

    context "when the aim is the same for X and Y" do
      let(:mouse_coordinates) do
        Gorillas::Coordinates.new(gorilla_coordinates.x + offset, gorilla_coordinates.y + offset)
      end
      it "returns a 45 deg angle" do
        expect(degrees(subject.angle)).to be_within(0.01).of(45)
      end
      it "returns correct speed" do
        expect(subject.velocity.x).to eq(offset)
        expect(subject.velocity.y).to eq(offset)
      end
      it "does not land offscreen" do
        expect(subject.lands_offscreen?).to be(false)
      end
    end
    context "when the aim is negative" do
      let(:offset) { -100 }
      let(:mouse_coordinates) do
        Gorillas::Coordinates.new(gorilla_coordinates.x + offset, gorilla_coordinates.y + 2 * offset)
      end
      it "returns a -45 deg angle" do
        expect(degrees(subject.angle)).to be_within(0.01).of(-116.56)
      end
      it "returns correct negative speed" do
        expect(subject.velocity.x).to eq(offset)
        expect(subject.velocity.y).to eq(2 * offset)
      end
      it "lands offscreen" do
        expect(subject.lands_offscreen?).to be(true)
      end
    end
  end
end
