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

  describe '#deploy_on' do
    let(:subject) { described_class.new('1 2 N') }
    let(:plateau) { Plateau.new('spec/fixtures/valid_mission') }

    it do
      expect { subject.deploy_on }
        .to raise_error(ArgumentError)
        .with_message /wrong number of arguments/
    end

    context 'when everything is fine' do
      it { expect { subject.deploy_on plateau }.not_to raise_error }

      it do
        subject.deploy_on plateau
        expect(subject.plateau).to eq plateau
      end

      it { expect(subject.deploy_on plateau).to eq subject }
    end
  end

  describe '#execute' do
    let(:subject) { described_class.new('2 3 N') }

    it do
      expect { subject.execute }
        .to raise_error(ArgumentError)
        .with_message /wrong number of arguments/
    end

    it do
      expect { subject.execute 'MMLLMMLL' }
        .to raise_error(InvalidPosition)
        .with_message /Not yet deployed on plateau/
    end

    it do
      allow_any_instance_of(Plateau).to receive(:x_range) { (0..1) }
      allow_any_instance_of(Plateau).to receive(:y_range) { (0..1) }
      subject.deploy_on Plateau.new('spec/fixtures/valid_mission')
      expect { subject.execute 'MMLLMMLL' }
        .to raise_error(InvalidPosition)
        .with_message /Invalid position on plateau/
    end

    it do
      subject.deploy_on Plateau.new('spec/fixtures/valid_mission')
      expect { subject.execute 'MMLLMMLLA' }.to raise_error(InvalidCommand)
    end

    context 'when everything is fine' do
      let(:plateau) { Plateau.new('spec/fixtures/valid_mission') }
      let(:subject) { described_class.new('1 2 N').tap { |rover| rover.deploy_on plateau } }

      it { expect { subject.execute 'LMLMLMLMM' }.not_to raise_error }
      it { expect(subject.execute 'LMLMLMLMM').to eq subject }
      it do
        subject.execute 'LMLMLMLMM'
        expect(subject.x).to eq 1
        expect(subject.y).to eq 3
        expect(subject.direction).to eq 'N'
      end
    end
  end
end
