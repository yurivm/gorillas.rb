require "spec_helper"

describe Gorillas::Coordinates do
  let(:x) { 100 }
  let(:y) { 200 }
  subject { described_class.new(x, y) }

  describe "#x_offscreen?" do
    context "when x is less than zero" do
      let(:x) { - 5 }
      it "returns true" do
        expect(subject.x_offscreen?).to eq(true)
      end
    end
    context "when x more than game window width" do
      let(:x) { Gorillas::GameWindow::SCREEN_WIDTH + 1 }
      it "returns true" do
        expect(subject.x_offscreen?).to eq(true)
      end
    end
    context "when x is within the game window" do
      let(:x) { Gorillas::GameWindow::SCREEN_WIDTH / 2 }
      it "returns false" do
        expect(subject.x_offscreen?).to eq(false)
      end
    end
  end

  describe "#y_offscreen?" do
    context "when y is less than zero" do
      let(:y) { - 5 }
      it "returns true" do
        expect(subject.y_offscreen?).to eq(true)
      end
    end
    context "when y more than game window width" do
      let(:y) { Gorillas::GameWindow::SCREEN_HEIGHT + 1 }
      it "returns true" do
        expect(subject.y_offscreen?).to eq(true)
      end
    end
    context "when y is within the game window" do
      let(:y) { Gorillas::GameWindow::SCREEN_HEIGHT / 2 }
      it "returns false" do
        expect(subject.y_offscreen?).to eq(false)
      end
    end
  end
end
