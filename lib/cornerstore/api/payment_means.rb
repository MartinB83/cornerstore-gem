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

  def paid?
    self.paid_at.is_a?(DateTime)
  end

  def refunded?
    self.refunded_at.is_a?(DateTime)
  end
end