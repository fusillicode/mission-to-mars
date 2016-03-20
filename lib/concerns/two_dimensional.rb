module TwoDimensional
  def dimensions_number
    2
  end

  def check_coordinates(coordinates)
    raise InvalidCoordinates.new('Incorrect number of coordinates') if coordinates.size != dimensions_number
    raise InvalidCoordinates.new('No digit coordinates') if no_digit_coordinates?(coordinates)
  end

  def no_digit_coordinates?(coordinates)
    coordinates.map { |c| c =~ /[[:alpha:]]/ }.any?
  end

  class InvalidCoordinates < StandardError; end
end
