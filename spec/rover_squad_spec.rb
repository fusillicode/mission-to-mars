require 'rspec'
require 'spec_helper'
require 'rover_squad'

describe RoverSquad do
  describe '#initialize' do
    it_behaves_like 'load mission file'

    context 'when everything is fine' do
      it do
        expect { described_class.new('spec/fixtures/valid_mission') }.not_to raise_error
      end
    end
  end

  describe '#rovers_with_commands_strings' do
    let(:subject) { described_class.new('spec/fixtures/valid_mission') }

    it { expect(subject.rovers_with_commands_strings).to be_an Array }

    it 'should be an Array of Array' do
      subject.rovers_with_commands_strings.each do |rover_with_commands_string|
        expect(rover_with_commands_string).to be_an Array
      end
    end

    it 'the inner Arrays have size 2' do
      subject.rovers_with_commands_strings.each do |rover_with_commands_string|
        expect(rover_with_commands_string.size).to eq 2
      end
    end

    it 'the first element of the inner Arrays should be a Rover object' do
      subject.rovers_with_commands_strings.each do |rover_with_commands_string|
        expect(rover_with_commands_string.first).to be_a Rover
      end
    end

    it 'the second element of the inner Arrays should be a String' do
      subject.rovers_with_commands_strings.each do |rover_with_commands_string|
        expect(rover_with_commands_string.last).to be_a String
      end
    end
  end
end
