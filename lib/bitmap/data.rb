module Bitmap
  class Data
    DEFAULT_COLOUR = 'O'.freeze
    VALID_SIZE_RANGE = 1..250
    VALID_COLOURS = 'A'..'Z'

    attr_accessor :width, :height, :data

    def initialize(w, h)
      @width = w.to_i
      @height = h.to_i

      validate_size

      @data = @data = Array.new(height) { Array.new(width, DEFAULT_COLOUR) }
    end

    def clear
    end

    def colour_pixel(x, y, colour)
      x, y = x.to_i, y.to_i
      validate_coordinates(x, y)
      validate_colour(colour)
      data[y - 1][x - 1] = colour
    end

    def draw_vertical_line(x, y1, y2, c)
    end

    def draw_horizontal_line(x1, x2, y, c)
    end

    def show
    end

    private

    def validate_size
      return if VALID_SIZE_RANGE.include?(width) && VALID_SIZE_RANGE.include?(height)
      raise "Image size #{[width, height]} is beyond the scope #{VALID_SIZE_RANGE}."
    end

    def validate_coordinates(x, y)
      return if (1..width).include?(x) && (1..height).include?(y)
      raise "Coordinates #{[x, y]} are beyond the image dimensions."
    end

    def validate_colour(colour)
      return if VALID_COLOURS.include?(colour)
      raise "Colour #{colour} is invalid."
    end
  end
end
