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
      reset_data
    end

    def clear
      reset_data
    end

    def colour_pixel(x, y, colour)
      x, y = x.to_i, y.to_i
      validate_coordinates(x, y)
      validate_colour(colour)
      data[y - 1][x - 1] = colour
    end

    def draw_vertical_line(x, y1, y2, colour)
      x, y1, y2 = x.to_i, y1.to_i, y2.to_i
      raise "Coordinate y1 is greater than y2 #{[y1, y2]}." if y1 > y2
      validate_coordinates(x, y2) # to avoid changing pixels in case when y2 is too large
      y1.upto(y2).each { |y| colour_pixel(x, y, colour) }
    end

    def draw_horizontal_line(x1, x2, y, colour)
      x1, x2, y = x1.to_i, x2.to_i, y.to_i
      raise "Coordinate x1 is greater than x2 #{[x1, x2]}." if x1 > x2
      validate_coordinates(x2, y) # to avoid changing pixels in case when x2 is too large
      x1.upto(x2).each { |x| colour_pixel(x, y, colour) }
    end

    def to_s
      data.map(&:join).join("\n")
    end

    private

    def validate_size
      return if VALID_SIZE_RANGE.include?(width) && VALID_SIZE_RANGE.include?(height)
      raise "Image size #{[width, height]} is beyond the scope #{VALID_SIZE_RANGE}."
    end

    def validate_coordinates(x, y)
      return if (1..width).include?(x) && (1..height).include?(y)
      raise "Coordinates #{[x, y]} are beyond the image dimensions #{[width, height]}."
    end

    def validate_colour(colour)
      return if VALID_COLOURS.include?(colour)
      raise "Colour #{colour} is invalid."
    end

    def reset_data
      @data = Array.new(height) { Array.new(width, DEFAULT_COLOUR) }
    end
  end
end
