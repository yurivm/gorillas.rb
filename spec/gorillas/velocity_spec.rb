require "spec_helper"

describe Gorillas::Velocity do
  describe "#magnitude" do
    subject { described_class.new(30, 100) }

    it "returns the speed vector magnitude" do
      expect(subject.magnitude).to be_within(0.1).of(104.40)
    end
  end
end
