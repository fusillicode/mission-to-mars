require 'rspec'
require 'spec_helper'
require 'plateau'

describe Plateau do
  describe '#initialize' do
    it_behaves_like 'load mission file'

    it do
      allow(File).to receive(:open).with('dummy_file_path').and_return(['1 2 3'])
      expect { described_class.new('dummy_file_path') }
        .to raise_error(InvalidCoordinates)
        .with_message /Incorrect number of coordinates/
    end

    it do
      allow(File).to receive(:open).with('dummy_file_path').and_return(['N 3'])
      expect { described_class.new('dummy_file_path') }
        .to raise_error(InvalidCoordinates)
        .with_message /No digit coordinates/
    end

    it do
      allow(File).to receive(:open).with('dummy_file_path').and_return(['-1 -1'])
      expect { described_class.new('dummy_file_path') }
        .to raise_error(InvalidPlateau)
        .with_message /Invalid plateau/
    end

    context 'when everything is fine' do
      let(:subject) { described_class.new('dummy_file_path') }
      before do
        allow(File).to receive(:open).with('dummy_file_path').and_return(['2 3'])
      end

      it do
        expect { described_class.new('dummy_file_path') }.not_to raise_error
      end

      it 'sets the bottom_left_coordinates' do
        expect(subject.bottom_left_coordinates).to eq [0, 0]
      end

      it 'sets the top_right_coordinates' do
        expect(subject.top_right_coordinates).to eq [2, 3]
      end
    end
  end

  describe '#default_bottom_left_coordinates' do
    let(:subject) do
      allow(File).to receive(:open).with('dummy_file_path').and_return(['2 3'])
      described_class.new('dummy_file_path')
    end

    it { expect(subject.default_bottom_left_coordinates).to eq [0, 0] }
  end

  describe '#x_range' do
    let(:subject) do
      allow(File).to receive(:open).with('dummy_file_path').and_return(['2 3'])
      described_class.new('dummy_file_path')
    end

    it { expect(subject.x_range).to eq (0..2) }
  end

  describe '#y_range' do
    let(:subject) do
      allow(File).to receive(:open).with('dummy_file_path').and_return(['2 3'])
      described_class.new('dummy_file_path')
    end

    it { expect(subject.y_range).to eq (0..3) }
  end
end
