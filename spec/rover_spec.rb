require 'rspec'
require 'spec_helper'
require 'rover'

describe Rover do
  describe '#initialize' do
    it do
      expect { described_class.new }
        .to raise_error(ArgumentError)
        .with_message /wrong number of arguments/
    end

    it do
      expect { described_class.new(121) }.to raise_error(InvalidStartConfiguration)
    end

    it do
      expect { described_class.new('1 2 3 N') }
        .to raise_error(TwoDimensional::InvalidCoordinates)
        .with_message /Incorrect number of coordinates/
    end

    it do
      expect { described_class.new('a 3 N') }
        .to raise_error(TwoDimensional::InvalidCoordinates)
        .with_message /No digit coordinates/
    end

    it do
      expect { described_class.new('1 3 A') }
        .to raise_error(InvalidDirection)
    end

    context 'when everything is fine' do
      let(:subject) { described_class.new('1 2 N') }
      it { expect { described_class.new('1 2 N') }.not_to raise_error }
      it { expect(subject.x).to eq 1 }
      it { expect(subject.y).to eq 2 }
      it { expect(subject.direction).to eq 'N' }
    end
  end

  # describe '#deploy_on' do
  #   let(:subject) { described_class.new('1 2 N') }

  #   it { expect(subject.deploy_on).to eq plateau }
  # end
end
