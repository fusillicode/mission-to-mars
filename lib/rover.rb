require_relative 'concerns/two_dimensional.rb'

class Rover
  include TwoDimensional

  attr_reader :x, :y, :direction, :plateau

  def initialize(start_configuration)
    start_configuration = parse_start_configuration start_configuration
    @x, @y = extract_coordinates(start_configuration)
    @direction = extract_direction(start_configuration)
  end

  def deploy_on(plateau)
    @plateau = plateau
    self
  end

  def execute(commands_string)
    raise InvalidPosition.new('Not yet deployed on plateau') unless plateau
    raise InvalidPosition.new('Invalid position on plateau') unless valid_position?
    extract_commands(commands_string).each do |command|
      execute_single_command command
    end
    self
  end

  def valid_directions
    %w(N E S W)
  end

  def valid_commands
    moving_commands + rotation_commands
  end

  def moving_commands
    %w(M)
  end

  def rotation_commands
    %w(R L)
  end

  def to_s
    "#{x} #{y} #{direction}"
  end

  private

  def execute_single_command(command)
    raise InvalidCommand.new('Invalid command') unless valid_command? command
    if rotation_commands.include? command
      rotate(command)
    else
      move
    end
  end

  def rotate(command)
    valid_directions.each_with_index do |d, i|
      index = command ? i + 1 : i - 1
      index = index < 0 ? 3 : (index > 3 ? 0 : index)
      if @direction == d
        @direction = valid_directions[index]
        break
      end
    end
  end

  def move(_step = 1)
    @y = y + 1 if direction == 'N'
    @x = x + 1 if direction == 'E'
    @y = y - 1 if direction == 'S'
    @x = x - 1 if direction == 'W'
  end

  def parse_start_configuration(start_configuration)
    raise InvalidStartConfiguration unless start_configuration.respond_to? :split
    start_configuration.split(' ')
  end

  def extract_coordinates(start_configuration)
    start_configuration
      .first(start_configuration.size - 1)
      .tap { |coordinates| check_coordinates coordinates }
      .map &:to_i
  end

  def extract_direction(start_configuration)
    start_configuration
      .last
      .tap { |direction| check_direction direction }
  end

  def extract_commands(commands)
    commands.strip.chars
  end

  def check_direction(direction)
    raise InvalidDirection.new unless valid_direction? direction
  end

  def valid_position?
    plateau.x_range.include?(x) && plateau.y_range.include?(y)
  end

  def valid_command?(command)
    valid_commands.include? command
  end

  def valid_direction?(direction)
    valid_directions.include? direction
  end
end

class InvalidStartConfiguration < StandardError; end
class InvalidDirection < StandardError; end
class InvalidPosition < StandardError; end
class InvalidCommand < StandardError; end
