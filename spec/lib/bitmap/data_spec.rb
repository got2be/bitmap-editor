require './lib/bitmap/data'

RSpec.describe Bitmap::Data do
  describe '.new' do
    let(:max_size) { 250 }
    let(:width) { Random.rand(max_size) + 1 }
    let(:height) { Random.rand(max_size) + 1 }
    let(:default_colour) { 'O' }

    subject { described_class.new(width, height) }

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

  xdescribe '.set_colour' do
  end

  xdescribe '.draw_vertical_line' do
  end

  xdescribe '.draw_horizontal_line' do
  end

  xdescribe '.show' do
  end
end
