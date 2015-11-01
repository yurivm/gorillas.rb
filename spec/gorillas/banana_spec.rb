require "spec_helper"

describe Gorillas::Banana do
  subject { described_class.new(start_coordinates) }

  describe "#update_position" do
  let(:mouse_coordinates) { Gorillas::Coordinates.new( start_coordinates.x + 20, start_coordinates.y + 40) }
  let(:calculator) do
    calc = Gorillas::ProjectileCalculator.new
    calc.set_values(
      start_coordinates,
      mouse_coordinates
    )
    calc.calculate_params
    calc
  end
    before do
      subject.launch(
        coordinates: start_coordinates,
        calculator: calculator,
        time: start_time
      )
    end
    context "with the banana at 0,0 starting at t=0" do
      let(:start_coordinates) { Gorillas::Coordinates.new(0, 0) }
      let(:start_time) { 0 }

      {
        0 =>      { x: 0, y: 0 },
        1000 =>   { x: 20, y: 44.9 },
        1200 =>   { x: 24, y: 55.06 },
        1400 =>   { x: 28, y: 65.61 },
        2000 =>   { x: 40, y: 99.62 },
        5000 =>   { x: 100, y: 322.62 },
        200_000 => { x: 4000, y: 204_200 }

      }.each_pair do |time, coordinates|
        it "calculates the coordinates correctly when game time equals #{time}" do
          subject.update_position(time)
          expect(subject.coordinates.x).to eq(coordinates[:x])
          expect(subject.coordinates.y).to be_within(0.1).of(coordinates[:y])
        end
      end
    end
    context "with the banana at 150,200 starting at t=10000" do
      let(:start_coordinates) { Gorillas::Coordinates.new(150, 200) }
      let(:start_time) { 10_000 }

      {
        0 =>        { x: 150, y: 200 },
        20_000 =>   { x: 350, y: 1090.5 },
        25_000 =>   { x: 450, y: 1903.63 },
        34_000 =>   { x: 630, y: 3985.28 },
        45_000 =>   { x: 850, y: 7608.63 },
        52_344 =>   { x: 996.88, y: 10_688.50 },
        200_000 => { x: 3950, y: 184_870.5 }

      }.each_pair do |time, coordinates|
        it "calculates the coordinates correctly when game time equals #{time}" do
          subject.update_position(time)
          expect(subject.coordinates.x).to be_within(0.1).of(coordinates[:x])
          expect(subject.coordinates.y).to be_within(0.1).of(coordinates[:y])
        end
      end
    end
  end
end
