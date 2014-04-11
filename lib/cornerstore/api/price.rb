class Cornerstore::Price < Cornerstore::Model::Base
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
    {
      gross: gross,
      net: net,
      tax_rate: tax_rate,
      currency: currency,
      amount: amount
    }
  end

  def <=> (other_object)
    case other_object
    when Integer, Float, Fixnum
      other_object <=> self.gross
    when Cornerstore::Price
      other_object.gross <=> self.gross
    else
      raise ArgumentError, "can only compare Integer, Float, Fixnum or Price objects with Price"
    end
  end

  def +(other_object)
    self.new({
      gross: gross + other_object.gross,
      net: net + other_object.net,
      currency: currency,
      tax_rate: other_object.tax_rate == tax_rate ? tax_rate : nil
    })
  end

  def to_f
    self.gross || self.amount
  end
end