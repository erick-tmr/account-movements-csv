require 'csv'
require_relative 'utils'

module AccountMovements
  class AccountsParser
    include Utils

    def initialize(accounts_path)
      @accounts_path = accounts_path
    end

    def parse
      accounts = {}

      CSV.foreach(@accounts_path, liberal_parsing: true, skip_blanks: true).with_index(1) do |row, line|
        account_id, balance = parse_row(row, line)

        accounts[account_id] = balance
      end

      accounts
    end

    private

    def parse_row(row, line)
      raise "Error while parsing accounts file, check line: #{line}" unless valid_row?(row)

      [Integer(row[0]), Integer(row[1])]
    end

    def valid_row?(row)
      return false if row.size != 2

      return false unless integer?(row[0]) && integer?(row[1])

      return false unless Integer(row[0]).positive?

      true
    end
  end
end
