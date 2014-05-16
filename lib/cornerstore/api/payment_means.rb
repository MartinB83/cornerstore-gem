class Cornerstore::PaymentMeans < Cornerstore::Model::Base
  attr_accessor :kind,
                :paid_at,
                :refunded_at,
                :card_token,
                :issuer,
                :last_digits,
                :owner,
                :bank,
                :iban,
                :swift_bic,
                :payment_id

  alias_method :type, :kind

  def initialize(attributes = {}, parent = nil)
    if attributes
      self.paid_at      = DateTime.parse(attributes.delete('paid_at')) unless attributes['paid_at'].blank?
      self.refunded_at  = DateTime.parse(attributes.delete('refunded_at')) unless attributes['refunded_at'].blank?
    end

    super
  end

  def paid?
    self.paid_at.is_a?(DateTime)
  end

  def refunded?
    self.refunded_at.is_a?(DateTime)
  end
end