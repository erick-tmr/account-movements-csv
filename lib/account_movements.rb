require_relative 'account_movements/runner'

AccountMovements::Runner.new.run(ARGV[0], ARGV[1])
