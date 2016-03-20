require_relative 'rover'

class RoverSquad
  attr_reader :rovers_with_commands_strings

  def initialize(mission_file_path)
    @rovers_with_commands_strings = create_rovers_with_commands_strings(mission_file_path)
  end

  private

  def create_rovers_with_commands_strings mission_file_path
    extract_rovers_instructions(mission_file_path).map do |raw_rover_instructions|
      [Rover.new(raw_rover_instructions.first), raw_rover_instructions.last]
    end
  end

  def extract_rovers_instructions mission_file_path
    File.open(mission_file_path)
      .drop(1)
      .select { |instruction| instruction != "\n" }
      .each_slice(2)
  end
end
