class Cornerstore::Price < Cornerstore::Model::Base
  include Comparable

  attr_accessor :gross,
                :net,
                :tax_rate,
                :currency,
                :amount

  validates :gross, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |p| not p.amount }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, if: Proc.new { |p| not p.gross }
  validates :net, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
  validates :currency, presence: true, inclusion: { in: %w( EUR USD ) }

  def attributes
    if gross or tax_rate
      {
        gross: gross,
        net: net,
        tax_rate: tax_rate,
        currency: currency
      }
    else
      {
        amount: amount,
        currency: currency
      }
    end
  end

  def <=> (other_object)
    case other_object
    when Integer, Float, Fixnum
      self.amount <=> other_object
    when Cornerstore::Price
      self.amount <=> other_object.amount
    else
      raise ArgumentError, 'can only compare Integer, Float, Fixnum or Price objects with Price'
    end
  end

  def +(other_object)
    return self if not other_object or other_object == 0

    if gross
      Cornerstore::Price.new({
        gross:    gross + other_object.gross,
        net:      net + other_object.net,
        currency: currency,
        tax_rate: other_object.tax_rate == tax_rate ? tax_rate : nil
      })
    else
      Cornerstore::Price.new({
        amount:   amount + other_object.amount,
        currency: currency
      })

    end
  end

  def to_f
    @amount || @gross
  end

  def amount
    @amount || @gross
  end

  def currency_symbol
    {
      'USD' => '$',
      'EUR' => '€',
    }[currency]
  end
end