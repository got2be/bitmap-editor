require './lib/bitmap/data'

module Bitmap
  class Editor
    attr_reader :file, :bitmap

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

    private

    def validate_file
      !file.nil? && File.file?(file) && File.readable?(file)
    end

    def process_line(line)
      args = line.split(' ')
      cmd = args.shift

      raise 'Please create image before manipulating it.' if cmd != 'I' && @bitmap.nil?

      case cmd
      when 'I'
        @bitmap = Data.new(*args)
      when 'C'
        bitmap.clear
      when 'L'
        bitmap.colour_pixel(*args)
      when 'V'
        bitmap.draw_vertical_line(*args)
      when 'H'
        bitmap.draw_horizontal_line(*args)
      when 'S'
        puts bitmap.to_s
      else
        raise 'Unrecognised command.'
      end
    end
  end
end
