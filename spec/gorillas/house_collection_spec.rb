require "spec_helper"

describe Gorillas::HouseCollection do
  let(:coordinates) { Gorillas::Coordinates.new(x: 100, y: 50) }
  let(:height) { 300 }
  let(:width) { 220 }
  let(:house) do
    Gorillas::House.new(
      coordinates: coordinates,
      height: height,
      width: width,
      color: "rainbow"
    )
  end

  subject { described_class.new }

  describe "#<<" do
    it "adds a house to the houses array" do
      subject.<<(house)
      expect(subject.houses.size).to eq(1)
    end

    it "adds a house that has given coordinates, width, height and color" do
      subject.<<(house)
      expect(subject.houses.first).to eq(house)
    end
  end

  describe "#house_at" do
    before do
      3.times { subject.add_adjacent_house }
    end
    it "returns a house at given X coordinate" do
      first_house = subject.houses.first
      first_x_end = first_house.x2
      expect(subject.house_at(first_x_end + 1)).to eq(subject.houses[1])
    end

    it "returns a house at given X coordinate if the house boundary ends at that X" do
      second_house = subject.houses[1]
      expect(subject.house_at(second_house.x)).to eq(subject.houses[0])
    end
  end

  describe "add_adjacent_house" do
    it "adds the first house with the X coordinate equal to 0" do
      subject.add_adjacent_house
      expect(subject.houses.first.x).to eq(0)
    end

    it "add subsequent houses with the X coordinate equal to (X + width) of the previous house" do
      3.times { subject.add_adjacent_house }
      [1, 2].each do |index|
        expect(subject.houses[index].x).to eq(subject.houses[index - 1].x2)
      end
    end

    it "shrinks the house width to fit GameWindow::SCREEN_WIDTH if it's too long" do
      6.times { subject.add_adjacent_house(width: 110) }
      subject.add_adjacent_house(width: 250)
      expect(subject.houses.last.width).to eq(140)
    end

    it "does not add houses offscreen" do
      8.times { subject.add_adjacent_house(width: 100) }
      subject.add_adjacent_house(width: 44)
      expect(subject.houses.count).to eq(8)
    end

    it "streches the last house if the remaining space is thinner than minimal house width" do
      7.times { subject.add_adjacent_house(width: 110) }
      expect(subject.houses.last.width).to eq(140)
    end

    it "fills up all the game window width" do
      20.times { subject.add_adjacent_house(width: 41) }
      expect(subject.houses.map(&:width).inject(:+)).to eq(Gorillas::GameWindow::SCREEN_WIDTH)
    end
  end
end
