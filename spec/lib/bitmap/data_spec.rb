require './lib/bitmap/data'

RSpec.describe Bitmap::Data do
  let(:max_size) { 250 }
  let(:width) { Random.rand(max_size) + 1 }
  let(:height) { Random.rand(max_size) + 1 }
  let(:default_colour) { 'O' }
  let(:described_obj) { described_class.new(width, height) }
  let(:groupped_data) { described_obj.data.flatten.group_by { |c| c } }

  shared_examples_for 'reset image data' do
    it 'fills image with default colour' do
      subject
      expect(described_obj.data.flatten.join).to eq(default_colour * width * height)
    end
  end

  shared_examples_for 'invalid coordinates' do
    it 'raises an error' do
      expect { subject }.to raise_error("Coordinates [#{x}, #{y}] are beyond the image dimensions #{[width, height]}.")
    end
  end

  shared_examples_for 'invalid colour' do
    it 'raises an error' do
      expect { subject }.to raise_error("Colour #{colour} is invalid.")
    end
  end

  describe '.new' do
    subject { described_obj }

    context 'args are not ok' do
      shared_examples_for 'invalid args' do
        it 'raises an error' do
          expect { subject }.to raise_error("Image size #{[width, height]} is beyond the scope 1..#{max_size}.")
        end
      end

      context 'width is too large' do
        let(:width) { max_size + 1 }
        it_behaves_like 'invalid args'
      end

      context 'width is too small' do
        let(:width) { 0 }
        it_behaves_like 'invalid args'
      end

      context 'height is too large' do
        let(:height) { max_size + 1 }
        it_behaves_like 'invalid args'
      end

      context 'height is too small' do
        let(:height) { 0 }
        it_behaves_like 'invalid args'
      end
    end

    context 'args are ok' do
      it 'creates image of specified size' do
        expect(subject.data.length).to eq(height)
        expect(subject.data.map(&:length).uniq).to eq([width])
      end

      it_behaves_like 'reset image data'
    end
  end

  describe '.clear' do
    subject { described_obj.clear }

    before { described_obj.colour_pixel(1, 1, 'A') }

    it_behaves_like 'reset image data'
  end

  describe '.colour_pixel' do
    let(:x) { Random.rand(width) + 1 }
    let(:y) { Random.rand(height) + 1 }
    let(:colour) { 'A' }

    subject { described_obj.colour_pixel(x, y, colour) }

    context 'coordinates are invalid' do
      context 'x coordinate is too small' do
        let(:x) { 0 }
        it_behaves_like 'invalid coordinates'
      end

      context 'x coordinate is too large' do
        let(:x) { width + 1 }
        it_behaves_like 'invalid coordinates'
      end

      context 'y coordinate is too large' do
        let(:y) { height + 1 }
        it_behaves_like 'invalid coordinates'
      end

      context 'y coordinate is too small' do
        let(:y) { 0 }
        it_behaves_like 'invalid coordinates'
      end
    end

    context 'colour is invalid' do
      let(:colour) { 'a' }

      it_behaves_like 'invalid colour'
    end

    context 'colour is valid' do
      it 'sets the colour of specified pixel' do
        expect { subject }.to change { described_obj.data[y - 1][x - 1] }.from(default_colour).to(colour)
      end

      it 'does not change other pixels' do
        subject
        expect(groupped_data[colour].length).to eq(1)
        expect(groupped_data[default_colour].length).to eq(width * height - 1)
      end
    end
  end

  describe '.draw_vertical_line' do
    let(:x) { Random.rand(width) + 1 }
    let(:y1) { Random.rand(height) + 1 }
    let(:y2) { Random.rand(y1..height) }
    let(:colour) { 'A' }

    subject { described_obj.draw_vertical_line(x, y1, y2, colour) }

    context 'args are invalid' do
      context 'x is too small' do
        let(:x) { 0 }
        let(:y) { y2 }
        it_behaves_like 'invalid coordinates'
      end

      context 'x is too large' do
        let(:x) { width + 1 }
        let(:y) { y2 }
        it_behaves_like 'invalid coordinates'
      end

      context 'y1 is too small' do
        let(:y1) { 0 }
        let(:y) { y1 }
        it_behaves_like 'invalid coordinates'
      end

      context 'y2 is too large' do
        let(:y2) { height + 1 }
        let(:y) { y2 }
        it_behaves_like 'invalid coordinates'
      end

      context 'y1 is greater than y2' do
        let(:height) { 10 } # reassign height to avoid 1x1 picture
        let(:y1) { 4 }
        let(:y2) { 3 }

        it 'raises an error' do
          expect { subject }.to raise_error("Coordinate y1 is greater than y2 #{[y1, y2]}.")
        end
      end

      context 'colour is invalid' do
        let(:colour) { 'a' }
        it_behaves_like 'invalid colour'
      end
    end

    context 'args are valid' do
      it 'changes colour of pixels correctly' do
        subject
        y1.upto(y2).each do |y|
          expect(described_obj.data[y - 1][x - 1]).to eq(colour)
        end
      end

      it 'does not change other pixels' do
        subject
        affected_pixels_num = y2 - y1 + 1
        expect(groupped_data[colour].length).to eq(affected_pixels_num)
        expect(groupped_data[default_colour].length).to eq(width * height - affected_pixels_num)
      end
    end
  end

  xdescribe '.draw_horizontal_line' do
  end

  xdescribe '.show' do
  end
end
