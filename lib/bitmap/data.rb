module Bitmap
  class Data
    DEFAULT_COLOUR = 'O'.freeze
    VALID_SIZE_RANGE = (1..250)

    attr_accessor :width, :height, :data

    def initialize(w, h)
      @width = w.to_i
      @height = h.to_i

      validate_size

      @data = @data = Array.new(height) { Array.new(width, DEFAULT_COLOUR) }
    end

    def clear
    end

    def set_colour(x, y, c)
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
  end
end
