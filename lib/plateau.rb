require_relative 'concerns/two_dimensional.rb'

class Plateau
  include TwoDimensional

  attr_reader :top_right_coordinates, :bottom_left_coordinates

  def initialize(mission_file_path)
    @bottom_left_coordinates = extract_bottom_left_coordinates || default_bottom_left_coordinates
    @top_right_coordinates = extract_top_right_coordinates mission_file_path
    raise InvalidPlateau.new('Invalid plateau') unless valid?
  end

  def x_range
    @x_range ||= (bottom_left_coordinates[0]..top_right_coordinates[0])
  end

  def y_range
    @y_range ||= (bottom_left_coordinates[1]..top_right_coordinates[1])
  end

  def default_bottom_left_coordinates
    Array.new dimensions_number, 0
  end

  private

  def extract_bottom_left_coordinates
    nil
  end

  def extract_top_right_coordinates(mission_file_path)
    File.open(mission_file_path)
        .first
        .split(' ')
        .tap { |coordinates| check_coordinates coordinates }
        .map &:to_i
  end

  def valid?
    top_right_coordinates[0] >= bottom_left_coordinates[0] &&
      top_right_coordinates[1] >= bottom_left_coordinates[1]
  end
end

class InvalidPlateau < StandardError; end
