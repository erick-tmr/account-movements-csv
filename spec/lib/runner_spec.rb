require 'account_movements/runner'

describe AccountMovements::Runner do
  let(:instance) { AccountMovements::Runner.new }
  let(:accounts_path) { 'some/acc_path.csv' }
  let(:transactions_path) { 'some/tra_path.csv' }

  describe '#run' do
    context 'with invalid file paths' do
      context 'with empty accounts path' do
        let(:accounts_path) { nil }

        it 'raises an error' do
          expect do
            instance.run(accounts_path, transactions_path)
          end.to raise_error(ArgumentError, 'Accounts and Transactions CSV file paths are required')
        end
      end

      context 'with empty transactions path' do
        let(:transactions_path) { nil }

        it 'raises an error' do
          expect do
            instance.run(accounts_path, transactions_path)
          end.to raise_error(ArgumentError, 'Accounts and Transactions CSV file paths are required')
        end
      end

      context 'with an inexistent file in accounts path' do
        it 'raises an error' do
          expect do
            instance.run(accounts_path, transactions_path)
          end.to raise_error(ArgumentError, 'Accounts CSV file path not valid')
        end
      end

      context 'with an inexistent file in transactions path' do
        it 'raises an error' do
          allow(File).to receive(:exist?).with(accounts_path).and_return true
          allow(File).to receive(:exist?).with(transactions_path).and_return false

          expect do
            instance.run(accounts_path, transactions_path)
          end.to raise_error(ArgumentError, 'Transactions CSV file path not valid')
        end
      end
    end

    context 'with valid file paths' do
      it 'prints the result to the STDOUT' do
        allow(File).to receive(:exist?).and_return true

        mocked_accounts = {
          1 => 1000,
          2 => -3300
        }
        accounts_double = double(parse: {})
        transactions_double = double(process_accounts: mocked_accounts)
        allow(AccountMovements::AccountsParser).to receive(:new).and_return accounts_double
        allow(AccountMovements::TransactionsProcessor).to receive(:new).and_return transactions_double

        expect do
          instance.run(accounts_path, transactions_path)
        end.to output("1,1000\n2,-3300\n").to_stdout
      end
    end
  end
end
