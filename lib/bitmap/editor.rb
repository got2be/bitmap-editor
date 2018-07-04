module Bitmap
  class Editor
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def run
      return puts "Please provide correct file." unless validate_file

      File.open(file).each do |line|
        line = line.chomp
        case line
          when 'S'
            puts "There is no image"
          else
            puts 'unrecognised command :('
        end
      end
    end

    private

    def validate_file
      !file.nil? && File.file?(file) && File.readable?(file)
    end
  end
end
