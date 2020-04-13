module SpreePayuGateway::Spree::Payment::ProcessingDecorator

  def process!
    if payment_method.is_a? Constants::PAYUIN_GATEWAY
      process_with_payu
    else
      super
    end
  end

  def cancel!
    if payment_method.is_a? Constants::PAYUIN_GATEWAY
      cancel_with_payu
    else
      super
    end
  end

  # private

  def cancel_with_payu
    handle_response(void_payment, :void, :failure)
  end

  # there is no credit card/source present so block was not invoking
  def process_with_payu
    process_purchase
  end

  def void_payment
    payment_method.cancel(transaction_id)
  end
end

Spree::Payment.prepend SpreePayuGateway::Spree::Payment::ProcessingDecorator