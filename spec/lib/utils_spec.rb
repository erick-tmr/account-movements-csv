require 'account_movements/utils'

describe AccountMovements::Utils do
  let(:dummy_class) { Class.new { extend AccountMovements::Utils } }

  context 'with valid string' do
    let(:input) { '1' }

    it 'returns true' do
      expect(dummy_class.integer?(input)).to eq(true)
    end
  end

  context 'with invalid string' do
    let(:input) { 'two' }

    it 'returns false' do
      expect(dummy_class.integer?(input)).to eq(false)
    end
  end
end
