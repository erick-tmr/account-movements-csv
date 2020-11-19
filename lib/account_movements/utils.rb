module AccountMovements
  module Utils
    def integer?(value)
      Integer(value, 10)

      true
    rescue ArgumentError
      false
    end
  end
end
