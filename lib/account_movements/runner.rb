require_relative 'accounts_parser'
require_relative 'transactions_processor'

module AccountMovements
  class Runner
    def run(accounts_path, transactions_path)
      if accounts_path.nil? || transactions_path.nil?
        raise ArgumentError, 'Accounts and Transactions CSV file paths are required'
      end

      raise ArgumentError, 'Accounts CSV file path not valid' unless File.exist?(accounts_path)

      raise ArgumentError, 'Transactions CSV file path not valid' unless File.exist?(transactions_path)

      accounts = AccountsParser.new(accounts_path).parse
      accounts = TransactionsProcessor.new(transactions_path, accounts).process_accounts

      print_result(accounts)
    end

    private

    def print_result(accounts)
      accounts.each do |account_id, balance|
        puts "#{account_id},#{balance}"
      end
    end
  end
end
