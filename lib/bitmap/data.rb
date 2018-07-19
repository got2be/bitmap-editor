module Bitmap
  class Data
    DEFAULT_COLOUR = 'O'.freeze
    VALID_SIZE_RANGE = 1..250
    VALID_COLOURS = 'A'..'Z'

    attr_accessor :width, :height, :data

    def initialize(width, height)
      @width, @height = width, height
      validate_size
      reset_data
    end

    def clear
      reset_data
    end

    def colour_pixel(x, y, colour)
      validate_coordinates!(x, y)
      validate_colour(colour)
      set_pixel_colour(x, y, colour)
    end

    def draw_vertical_line(x, y1, y2, colour)
      raise "Coordinate y1 is greater than y2 #{[y1, y2]}." if y1 > y2
      validate_coordinates!(x, y2) # to avoid changing pixels in case when y2 is too large
      y1.upto(y2).each { |y| colour_pixel(x, y, colour) }
    end

    def draw_horizontal_line(x1, x2, y, colour)
      raise "Coordinate x1 is greater than x2 #{[x1, x2]}." if x1 > x2
      validate_coordinates!(x2, y) # to avoid changing pixels in case when x2 is too large
      x1.upto(x2).each { |x| colour_pixel(x, y, colour) }
    end

    def to_s
      data.map(&:join).join("\n")
    end

    def fill(x, y, colour)
      validate_coordinates!(x, y)
      validate_colour(colour)
      required_colour = data[y - 1][x - 1]

      maybe_colour_pixel_with_neighbours(x, y, colour, required_colour)
    end

    private

    # TODO: rename to smth more adequate
    def maybe_colour_pixel_with_neighbours(x, y, colour, required_colour)
      return unless can_colour_pixel?(x, y, required_colour)

      set_pixel_colour(x, y, colour)

      maybe_colour_pixel_with_neighbours(x - 1, y, colour, required_colour)
      maybe_colour_pixel_with_neighbours(x + 1, y, colour, required_colour)
      maybe_colour_pixel_with_neighbours(x, y - 1, colour, required_colour)
      maybe_colour_pixel_with_neighbours(x, y + 1, colour, required_colour)
    end

    def can_colour_pixel?(x, y, colour)
      validate_coordinates(x, y) && data[y - 1][x - 1] == colour
    end

    def validate_size
      return if VALID_SIZE_RANGE.cover?(width) && VALID_SIZE_RANGE.cover?(height)
      raise "Image size #{[width, height]} is beyond the scope #{VALID_SIZE_RANGE}."
    end

    def validate_coordinates(x, y)
      (1..width).cover?(x) && (1..height).cover?(y)
    end

    def validate_coordinates!(x, y)
      raise "Coordinates #{[x, y]} are beyond the image dimensions #{[width, height]}." unless validate_coordinates(x, y)
    end

    def validate_colour(colour)
      return if VALID_COLOURS.cover?(colour)
      raise "Colour #{colour} is invalid."
    end

    def reset_data
      @data = Array.new(height) { Array.new(width, DEFAULT_COLOUR) }
    end

    def set_pixel_colour(x, y, colour)
      data[y - 1][x - 1] = colour
    end
  end
end
