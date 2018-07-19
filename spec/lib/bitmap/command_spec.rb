require './lib/bitmap/editor'

RSpec.describe Bitmap::Command do
  let(:editor) { instance_double(Bitmap::Editor) }

  context '.perform' do
    subject { described_class.new(cmd, args, editor).perform }

    shared_examples_for 'command with wrong argument number' do
      it 'raises error' do
        expect { subject }.to raise_error("Wrong number of arguments. Expected #{expected}, got #{got}.")
      end
    end

    shared_examples_for 'command with invalid argument' do
      it 'raises error' do
        expect { subject }.to raise_error("Invalid argument error. Expected #{expected}, got \"#{got}\".")
      end
    end

    context 'cmd == I' do
      let(:cmd) { 'I' }

      context 'no args passed' do
        let(:args) { [] }
        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 2 }
          let(:got) { 0 }
        end
      end

      context 'odd args passed' do
        let(:args) { %w(1 1 2) }
        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 2 }
          let(:got) { 3 }
        end
      end

      context 'invalid first arg' do
        let(:args) { %w(a 1) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid second arg' do
        let(:args) { %w(1 a) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'args are correct' do
        let(:args) { %w(1 1) }

        it 'calls editor.create_bitmap' do
          expect(editor).to receive(:create_bitmap).with(args[0].to_i, args[1].to_i).once
          subject
        end
      end
    end

    shared_examples_for 'command with no required args' do
      context 'odd args passed' do
        let(:args) { %w(1) }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 0 }
          let(:got) { 1 }
        end
      end

      context 'no args passed' do
        let(:args) { [] }

        it 'calls editor.clear' do
          expect(editor).to receive(method).with(no_args).once
          subject
        end
      end
    end

    context 'cmd == C' do
      let(:cmd) { 'C' }
      it_behaves_like 'command with no required args' do
        let(:method) { :clear }
      end
    end

    context 'cmd == L' do
      let(:cmd) { 'L' }

      context 'no args passed' do
        let(:args) { [] }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 3 }
          let(:got) { 0 }
        end
      end

      context 'odd args passed' do
        let(:args) { %w(2 2 B B) }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 3 }
          let(:got) { 4 }
        end
      end

      context 'invalid first arg' do
        let(:args) { %w(a 2 B) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid second arg' do
        let(:args) { %w(2 a B) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid third arg' do
        let(:args) { %w(2 2 BBB) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'char' }
          let(:got) { 'BBB' }
        end
      end

      context 'args are correct' do
        let(:args) { %w(2 2 B) }

        it 'calls editor.colour_pixel' do
          expect(editor).to receive(:colour_pixel).with(args[0].to_i, args[1].to_i, args[2]).once
          subject
        end
      end
    end

    context 'cmd == F' do
      let(:cmd) { 'F' }

      context 'no args passed' do
        let(:args) { [] }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 3 }
          let(:got) { 0 }
        end
      end

      context 'odd args passed' do
        let(:args) { %w(2 2 B B) }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 3 }
          let(:got) { 4 }
        end
      end

      context 'invalid first arg' do
        let(:args) { %w(a 2 B) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid second arg' do
        let(:args) { %w(2 a B) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid third arg' do
        let(:args) { %w(2 2 BBB) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'char' }
          let(:got) { 'BBB' }
        end
      end

      context 'args are correct' do
        let(:args) { %w(2 2 B) }

        it 'calls editor.fill' do
          expect(editor).to receive(:fill).with(args[0].to_i, args[1].to_i, args[2]).once
          subject
        end
      end
    end

    shared_examples_for 'draw line command' do
      context 'no args passed' do
        let(:args) { [] }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 4 }
          let(:got) { 0 }
        end
      end

      context 'odd args passed' do
        let(:args) { %w(3 4 5 C C) }

        it_behaves_like 'command with wrong argument number' do
          let(:expected) { 4 }
          let(:got) { 5 }
        end
      end

      context 'invalid first arg' do
        let(:args) { %w(a 4 5 C) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid second arg' do
        let(:args) { %w(3 a 5 C) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid third arg' do
        let(:args) { %w(3 4 a C) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'integer' }
          let(:got) { 'a' }
        end
      end

      context 'invalid fourth arg' do
        let(:args) { %w(3 4 5 CCC) }
        it_behaves_like 'command with invalid argument' do
          let(:expected) { 'char' }
          let(:got) { 'CCC' }
        end
      end

      context 'args are correct' do
        let(:args) { %w(3 4 5 C) }

        it 'calls editor.colour_pixel' do
          expect(editor).to receive(method).with(args[0].to_i, args[1].to_i, args[2].to_i, args[3]).once
          subject
        end
      end
    end

    context 'cmd == V' do
      let(:cmd) { 'V' }
      it_behaves_like 'draw line command' do
        let(:method) { :draw_vertical_line }
      end
    end

    context 'cmd == H' do
      let(:cmd) { 'H' }
      it_behaves_like 'draw line command' do
        let(:method) { :draw_horizontal_line }
      end
    end

    context 'cmd == S' do
      let(:cmd) { 'S' }
      it_behaves_like 'command with no required args' do
        let(:method) { :show }
      end
    end

    context 'cmd is invalid' do
      let(:cmd) { 'Z' }
      let(:args) { [] }

      it 'raises error' do
        expect { subject }.to raise_error("Unrecognised command.")
      end
    end
  end
end
