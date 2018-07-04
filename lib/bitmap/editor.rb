module Bitmap
  class Editor

    def run(file)
      return puts "Please provide correct file." unless validate_file(file)

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

    def validate_file(file)
      !file.nil? && File.exists?(file) && File.readable?(file)
    end
  end
end
