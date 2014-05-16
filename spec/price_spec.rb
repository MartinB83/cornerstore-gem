require 'spec_helper'

describe Cornerstore::Price do
  context 'regarding basic attributes' do
    it 'should correctly return amount and currency' do
      p = Cornerstore::Price.new({'amount' => 29.00, 'currency' => 'USD'})

      expect(p.amount).to eq(29.00)
      expect(p.currency).to eq('USD')
      expect(p.currency_symbol).to eq('$')
    end

    it 'should correctly return attributes for VAT prices' do
      p = Cornerstore::Price.new({'gross' => 17.85, 'net' => 15.00, 'tax_rate' => 0.19, 'currency' => 'EUR'})

      expect(p.amount).to eq(17.85)
      expect(p.gross).to eq(17.85)
      expect(p.net).to eq(15.00)
      expect(p.tax_rate).to eq(0.19)
      expect(p.currency).to eq('EUR')
      expect(p.currency_symbol).to eq('€')
    end
  end

  context 'regarding math operations' do
    it 'should compare two prices' do
      p1 = Cornerstore::Price.new({'amount' => 29.00, 'currency' => 'USD'})
      p2 = Cornerstore::Price.new({'amount' => 35.00, 'currency' => 'USD'})

      expect(p2 > 20).to eql(true)
      expect(p2 > 40).to eql(false)
      expect(p2 > p1).to eql(true)
    end

    it 'should sum two prices' do
      p1 = Cornerstore::Price.new({'amount' => 29.00, 'currency' => 'USD'})
      p2 = Cornerstore::Price.new({'amount' => 35.00, 'currency' => 'USD'})

      p3 = p1 + p2
      expect(p3.amount).to eql(64.00)

      p1 = Cornerstore::Price.new({'gross' => 17.85, 'net' => 15.00, 'tax_rate' => 0.19, 'currency' => 'EUR'})
      p2 = Cornerstore::Price.new({'gross' =>  9.52, 'net' =>  8.00, 'tax_rate' => 0.19, 'currency' => 'EUR'})

      p3 = p1 + p2
      expect(p3.gross).to eql(27.37)
      expect(p3.net).to eql(23.00)
      expect(p3.tax_rate).to eql(0.19)
    end
  end
end