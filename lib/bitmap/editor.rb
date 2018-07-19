require_relative 'command'
require_relative 'data'

module Bitmap
  class Editor
    attr_accessor :file, :bitmap

    def initialize(file)
      @file = file
    end

    def run
      return puts "Please provide correct file." unless validate_file

      File.open(file).each.with_index do |line, i|
        line = line.chomp
        begin
          process_line(line)
        rescue StandardError => e
          puts "An error occured in line #{i + 1} (#{line})"
          puts e.message
          break
        end
      end
    end

    def create_bitmap(*args)
      @bitmap = Data.new(*args)
    end

    def clear
      check_bitmap
      bitmap.clear
    end

    def colour_pixel(*args)
      check_bitmap
      bitmap.colour_pixel(*args)
    end

    def draw_vertical_line(*args)
      check_bitmap
      bitmap.draw_vertical_line(*args)
    end

    def draw_horizontal_line(*args)
      check_bitmap
      bitmap.draw_horizontal_line(*args)
    end

    def show
      check_bitmap
      puts bitmap.to_s
    end

    def fill(*args)
      check_bitmap
      bitmap.fill(*args)
    end

    private

    def validate_file
      !file.nil? && File.file?(file) && File.readable?(file)
    end

    def process_line(line)
      cmd, *args = line.split
      Command.new(cmd, args, self).perform
    end

    def check_bitmap
      return if @bitmap
      raise 'Please create image before manipulating it.'
    end
  end
end
