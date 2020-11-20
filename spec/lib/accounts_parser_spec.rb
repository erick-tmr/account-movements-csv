require 'account_movements/accounts_parser'

describe AccountMovements::AccountsParser do
  let(:instance) { AccountMovements::AccountsParser.new(file_path) }
  let(:file_path) { "#{__dir__}/data/accounts/#{file}" }

  describe '#parse' do
    context 'with a valid file' do
      let(:file) { 'valid_sample.csv' }

      it 'returns an account parsed hash' do
        expect(instance.parse).to eq({ 1 => 200, 2 => -30 })
      end
    end

    context 'with an invalid file' do
      context 'with not integer values' do
        let(:file) { 'invalid_not_integer.csv' }

        it 'raises an error' do
          expect do
            instance.parse
          end.to raise_error(RuntimeError, 'Error while parsing accounts file, check line: 2')
        end
      end

      context 'with line with invalid format' do
        let(:file) { 'invalid_format.csv' }

        it 'raises an error' do
          expect do
            instance.parse
          end.to raise_error(RuntimeError, 'Error while parsing accounts file, check line: 3')
        end
      end

      context 'with line with invalid format' do
        let(:file) { 'invalid_negative_id.csv' }

        it 'raises an error' do
          expect do
            instance.parse
          end.to raise_error(RuntimeError, 'Error while parsing accounts file, check line: 1')
        end
      end
    end
  end
end
