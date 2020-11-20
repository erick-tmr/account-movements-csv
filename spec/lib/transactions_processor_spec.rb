require 'account_movements/transactions_processor'

describe AccountMovements::TransactionsProcessor do
  let(:instance) { AccountMovements::TransactionsProcessor.new(file_path, accounts) }
  let(:file_path) { "#{__dir__}/data/transactions/#{file}" }
  let(:accounts) { { 1 => 100, 2 => -300 } }

  describe '#process_accounts' do
    context 'with valid input' do
      let(:file) { 'valid_sample.csv' }

      context 'without account existing' do
        let(:accounts) { { 1 => 100 } }

        it 'process the transaction to a zero balance account' do
          response = instance.process_accounts

          expect(response.key?(2)).to eq(true)
          expect(response[2]).to eq(-600)
        end
      end

      context 'with multiple negative transactions' do
        let(:file) { 'valid_multiple_negative.csv' }

        it 'charges the negative balance fee every time' do
          expect(instance.process_accounts[2]).to eq(-1300)
        end
      end
    end

    context 'with an invalid file' do
      context 'with not integer values' do
        let(:file) { 'invalid_not_integer.csv' }

        it 'raises an error' do
          expect do
            instance.process_accounts
          end.to raise_error(RuntimeError, 'Error while parsing transactions file, check line: 2')
        end
      end

      context 'with line with invalid format' do
        let(:file) { 'invalid_format.csv' }

        it 'raises an error' do
          expect do
            instance.process_accounts
          end.to raise_error(RuntimeError, 'Error while parsing transactions file, check line: 3')
        end
      end

      context 'with line with invalid format' do
        let(:file) { 'invalid_negative_id.csv' }

        it 'raises an error' do
          expect do
            instance.process_accounts
          end.to raise_error(RuntimeError, 'Error while parsing transactions file, check line: 1')
        end
      end
    end
  end
end
