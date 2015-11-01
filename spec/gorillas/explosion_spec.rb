require "spec_helper"

describe Gorillas::Explosion do
  let(:coordinates) { Gorillas::Coordinates.new(50, 100) }
  subject { described_class.new(coordinates) }
end
