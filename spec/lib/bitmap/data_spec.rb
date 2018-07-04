require './lib/bitmap/data'

RSpec.describe Bitmap::Data do
  let(:max_size) { 250 }
  let(:width) { Random.rand(max_size) + 1 }
  let(:height) { Random.rand(max_size) + 1 }
  let(:default_colour) { 'O' }
  let(:described_obj) { described_class.new(width, height) }

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

      it 'fills image with default colour' do
        expect(subject.data.map(&:join).join).to eq(default_colour * width * height)
      end
    end
  end

  xdescribe '.clear' do
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

      it 'raises an error' do
        expect { subject }.to raise_error("Colour #{colour} is invalid.")
      end
    end

    context 'colour is valid' do
      let(:groupped_data) { described_obj.data.flatten.group_by { |c| c } }

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

  xdescribe '.draw_vertical_line' do
  end

  xdescribe '.draw_horizontal_line' do
  end

  xdescribe '.show' do
  end
end
