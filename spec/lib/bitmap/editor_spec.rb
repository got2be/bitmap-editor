require './lib/bitmap/editor'

RSpec.describe Bitmap::Editor do
  let(:file) { 'examples/show.txt' }
  let(:described_obj) { described_class.new(file) }

  shared_examples_for 'bad file' do
    it 'returns error message' do
      expect($stdout).to receive(:puts).with('Please provide correct file.').once
      subject
    end
  end

  shared_examples_for 'manipulating nonexistent data' do
    it 'raises error' do
      expect { subject }.to raise_error('Please create image before manipulating it.')
    end
  end

  shared_examples_for 'manipulating nexistent data' do
    let(:bitmap_data) { instance_double(Bitmap::Data) }
    before { described_obj.bitmap = bitmap_data }

    it 'calls corresponding bitmap method' do
      expect(bitmap_data).to receive(method).with(*args).once
      subject
    end
  end

  context '.run' do
    let(:stdout) { $stdout }
    subject { described_obj.run }

    # removing following lines adds some trash to rspec output
    before { $stdout = StringIO.new }
    after { $stdout = stdout }

    context 'something wrong with the file' do
      context 'file name is nil' do
        let(:file) { nil }
        it_behaves_like 'bad file'
      end

      context 'file does not exist' do
        let(:file) { 'gangnamstyle_lyrics.txt' }
        it_behaves_like 'bad file'
      end

      context 'file is a directory' do
        let(:file) { 'lib' }
        it_behaves_like 'bad file'
      end

      context 'file is not readable' do
        before { allow(File).to receive(:readable?).with(file).and_return(false) }
        it_behaves_like 'bad file'
      end
    end

    context 'file is ok' do
      let(:fake_file) { StringIO.new }
      before { allow(File).to receive(:open).with(file).and_return(fake_file) }

      context 'file is empty' do
        it 'does nothing' do
          expect { subject }.not_to raise_error
        end
      end

      context 'file contains commands' do
        context 'command raises error' do
          before do
            fake_file.puts('V 1 2 3 A')
            fake_file.puts('L 1 2 A')
            fake_file.rewind
            allow(Bitmap::Command).to receive(:new).with('V', %w(1 2 3 A), described_obj).and_raise('Some error.')
          end

          it 'returns error message' do
            expect($stdout).to receive(:puts).with('An error occured in line 1 (V 1 2 3 A)').once
            expect($stdout).to receive(:puts).with('Some error.').once
            subject
          end

          it 'does not process further commands' do
            expect(Bitmap::Command).not_to receive(:new).with('S', %w(1 2 A), described_obj)
            subject
          end
        end

        context 'valid commands' do
          let(:command1) { instance_double(Bitmap::Command) }
          let(:command2) { instance_double(Bitmap::Command) }
          let(:command3) { instance_double(Bitmap::Command) }

          before do
            fake_file.puts('I 10 20')
            fake_file.puts('L 1 2 A')
            fake_file.puts('S')
            fake_file.rewind
            allow(Bitmap::Command).to receive(:new).with('I', %w(10 20), described_obj).and_return(command1)
            allow(Bitmap::Command).to receive(:new).with('L', %w(1 2 A), described_obj).and_return(command2)
            allow(Bitmap::Command).to receive(:new).with('S', [], described_obj).and_return(command3)
          end

          it 'processes all commands one by one' do
            expect(command1).to receive(:perform)
            expect(command2).to receive(:perform)
            expect(command3).to receive(:perform)
            subject
          end
        end
      end
    end
  end

  context '.create_bitmap' do
    subject { described_obj.create_bitmap(10, 20) }

    context 'bitmap data is not created yet' do
      let(:bitmap_data) { instance_double(Bitmap::Data) }

      before do
        allow(Bitmap::Data).to receive(:new).with(10, 20).and_return(bitmap_data)
      end

      it 'creates new bitmap data' do
        expect { subject }.to change { described_obj.bitmap }.from(nil).to(bitmap_data)
      end
    end

    context 'bitmap data exists' do
      let(:old_bitmap_data) { instance_double(Bitmap::Data) }
      let(:bitmap_data) { instance_double(Bitmap::Data) }

      before do
        described_obj.bitmap = old_bitmap_data
        allow(Bitmap::Data).to receive(:new).with(10, 20).and_return(bitmap_data)
      end

      it 'creates new bitmap data' do
        expect { subject }.to change { described_obj.bitmap }.from(old_bitmap_data).to(bitmap_data)
      end
    end
  end

  context '.clear' do
    subject { described_obj.clear }

    context 'bitmap data is not created yet' do
      it_behaves_like 'manipulating nonexistent data'
    end

    it_behaves_like 'manipulating nexistent data' do
      let(:method) { :clear }
      let(:args) { no_args }
    end
  end

  context '.colour_pixel' do
    subject { described_obj.colour_pixel(1, 2, 'A') }

    context 'bitmap data is not created yet' do
      it_behaves_like 'manipulating nonexistent data'
    end

    context 'bitmap data exists' do
      it_behaves_like 'manipulating nexistent data' do
        let(:method) { :colour_pixel }
        let(:args) { [1, 2, 'A'] }
      end
    end
  end

  context '.draw_vertical_line' do
    subject { described_obj.draw_vertical_line(1, 2, 3, 'A') }

    context 'bitmap data is not created yet' do
      it_behaves_like 'manipulating nonexistent data'
    end

    context 'bitmap data exists' do
      it_behaves_like 'manipulating nexistent data' do
        let(:method) { :draw_vertical_line }
        let(:args) { [1, 2, 3, 'A'] }
      end
    end
  end

  context '.draw_horizontal_line' do
    subject { described_obj.draw_horizontal_line(1, 2, 3, 'A') }

    context 'bitmap data is not created yet' do
      it_behaves_like 'manipulating nonexistent data'
    end

    context 'bitmap data exists' do
      it_behaves_like 'manipulating nexistent data' do
        let(:method) { :draw_horizontal_line }
        let(:args) { [1, 2, 3, 'A'] }
      end
    end
  end

  context '.show' do
    subject { described_obj.show }

    context 'bitmap data is not created yet' do
      it_behaves_like 'manipulating nonexistent data'
    end

    context 'bitmap data exists' do
      let(:bitmap_data) { instance_double(Bitmap::Data, to_s: "OOO\nOAO\nOOO") }
      before { described_obj.bitmap = bitmap_data }

      it 'calls prints bitmap' do
        expect($stdout).to receive(:puts).with("OOO\nOAO\nOOO").once
        subject
      end
    end
  end
end
