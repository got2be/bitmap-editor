require './lib/bitmap/editor'

RSpec.describe Bitmap::Editor do
  context '.run' do
    let(:file) { 'examples/show.txt' }
    subject { described_class.new(file).run }

    context 'something wrong with the file' do
      shared_examples_for 'bad file' do
        it 'returns error message' do
          expect($stdout).to receive(:puts).with('Please provide correct file.').once
          subject
        end
      end

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

      shared_examples_for 'invalid command' do
        it 'returns error message' do
          error_messages.each do |msg|
            expect($stdout).to receive(:puts).with(msg).once
          end
          subject
        end
      end

      context 'the first command does not create new image' do
        before do
          fake_file.puts('V 1 2 3 A')
          fake_file.rewind
        end

        it_behaves_like 'invalid command' do
          let(:error_messages) do
            [
              'An error occured in line 1 (V 1 2 3 A)',
              'Please create image before manipulating it.'
            ]
          end
        end
      end

      context 'the first command creates new image' do
        before { fake_file.puts('I 10 20') }

        context 'args are invalid' do
          before do
            fake_file.rewind
            allow(Bitmap::Data).to receive(:new).with('10', '20').and_raise('Some error')
          end

          it_behaves_like 'invalid command' do
            let(:error_messages) do
              [ 'An error occured in line 1 (I 10 20)', 'Some error' ]
            end
          end
        end

        context 'args are valid' do
          let(:bitmap) { instance_double(Bitmap::Data) }

          before do
            allow(Bitmap::Data).to receive(:new).with('10', '20').and_return(bitmap)
          end

          shared_examples_for 'command call with args' do
            context 'call with args' do
              before do
                fake_file.puts(cmd)
                fake_file.rewind
              end

              it 'calls proper bitmap method' do
                expect(bitmap).to receive(method).with(*args).once
                subject
              end
            end

            context 'call with no args' do
              let(:cmd_without_args) { cmd.chars.first }
              before do
                fake_file.puts(cmd_without_args)
                fake_file.rewind
                allow(bitmap).to receive(method)
              end

              it_behaves_like 'invalid command' do
                let(:error_messages) do
                  [
                    "An error occured in line 2 (#{cmd_without_args})",
                    "Wrong number of arguments. Expected #{args.length}, got 0."
                  ]
                end
              end
            end

            context 'method raises error' do
              before do
                fake_file.puts(cmd)
                fake_file.rewind
                allow(bitmap).to receive(method).with(*args).and_raise('Some error')
              end

              it_behaves_like 'invalid command' do
                let(:error_messages) do
                  [
                    "An error occured in line 2 (#{cmd})",
                    'Some error'
                  ]
                end
              end
            end
          end

          context 'C command' do
            context 'no args passed' do
              before do
                fake_file.puts('C')
                fake_file.rewind
              end

              it 'calls bitmap.clear with no args' do
                expect(bitmap).to receive(:clear).with(no_args).once
                subject
              end
            end

            context 'some odd args passed' do
              before do
                fake_file.puts('C 1 2')
                fake_file.rewind
              end

              it 'ignores args' do
                expect(bitmap).to receive(:clear).with(no_args).once
                subject
              end
            end
          end

          context 'L command' do
            it_behaves_like 'command call with args' do
              let(:cmd) { 'L 2 2 A' }
              let(:args) { ['2', '2', 'A'] }
              let(:method) { :colour_pixel }
            end
          end

          context 'V command' do
            it_behaves_like 'command call with args' do
              let(:cmd) { 'V 2 5 7 A' }
              let(:args) { ['2', '5', '7', 'A'] }
              let(:method) { :draw_vertical_line }
            end
          end

          context 'H command' do
            it_behaves_like 'command call with args' do
              let(:cmd) { 'H 2 5 7 A' }
              let(:args) { ['2', '5', '7', 'A'] }
              let(:method) { :draw_horizontal_line }
            end
          end

          context 'S command' do
            before do
              fake_file.puts('S')
              fake_file.rewind
              allow(bitmap).to receive(:to_s).and_return("OOO\nAAA\nOOO")
            end

            it 'prints the result' do
              expect($stdout).to receive(:puts).with(bitmap.to_s).once
              subject
            end
          end

          context 'unrecognised command' do
            before do
              fake_file.puts('Z')
              fake_file.rewind
            end

            it_behaves_like 'invalid command' do
              let(:error_messages) do
                [
                  "An error occured in line 2 (Z)",
                  'Unrecognised command.'
                ]
              end
            end
          end
        end
      end
    end
  end
end
