require 'csv'
require_relative 'utils'

module AccountMovements
  class TransactionsProcessor
    include Utils

    NEGATIVE_BALANCE_FEE = 300

    def initialize(transactions_path, accounts)
      @transactions_path = transactions_path
      @accounts = accounts
    end

    def process_accounts
      CSV.foreach(@transactions_path, liberal_parsing: true, skip_blanks: true).with_index(1) do |row, line|
        account_id, transaction = parse_row(row, line)

        change_balance(account_id, transaction)
      end

      @accounts
    end

    private

    def parse_row(row, line)
      raise "Error while parsing transactions file, check line: #{line}" unless valid_row?(row)

      [Integer(row[0]), Integer(row[1])]
    end

    def valid_row?(row)
      return false if row.size != 2

      return false unless integer?(row[0]) && integer?(row[1])

      return false unless Integer(row[0]).positive?

      true
    end

    def change_balance(account_id, transaction)
      if @accounts[account_id].nil?
        @accounts[account_id] = transaction

        @accounts[account_id] -= self.class::NEGATIVE_BALANCE_FEE if @accounts[account_id].negative?

        return
      end

      @accounts[account_id] += transaction

      @accounts[account_id] -= self.class::NEGATIVE_BALANCE_FEE if @accounts[account_id].negative?
    end
  end
end
