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
  end
end
