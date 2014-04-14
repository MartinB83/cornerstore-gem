require 'spec_helper'

describe Cornerstore::Order do
  before(:all) do
    json = '{"_id":"53448a01417175b106ec0000","_slugs":["14521135"],"billing_address":{"_id":"53448a05417175b1069e0300","addition":null,"company":null,"country":"United States","firstname":"Ellis","name":"Bailey","number":"441","state":"New Hampshire","street":"Karli View","town":"North Penelope","zip":"26662"},"canceled_email_callback_url":"http://burger-store.dev/mails/canceled_notification","cart_url":"http://burger-store.dev/cart","checkout_id":"13d583c4340d9bfe52aa1f7cb92735c5f5b748135f170b4d5cd752c9fd25f149","checkout_started_at":null,"created_at":"2014-04-08T09:24:57.556Z","customer_comment":null,"customer_id":"53448a05417175b1069f0300","delivery_note_pdf_callback_url":null,"invoice_number":null,"invoice_pdf_callback_url":"http://burger-store.dev/documents/invoice","invoiced_at":null,"line_items":[{"_id":"53448a01417175b106ed0000","created_at":"2014-04-08T23:45:05.575Z","description":"PepsiCo Welch\'s Grape Soda – Packungsgröße: 12er Pack","order_number":"SBS-0009B","price":{"gross":15.5,"currency":"EUR","net":13.03,"tax_rate":0.19,"tax":2.47},"product_id":"53448a00417175b106450000","qty":5,"requires_shipment":true,"total":{"gross":77.5,"currency":"EUR","net":65.13,"tax_rate":0.19,"tax":12.37},"total_weight":15.0,"unit":"Pack","updated_at":"2014-04-08T23:45:05.575Z","variant_id":"53448a00417175b106480000","weight":3.0},{"_id":"53448a01417175b106ee0000","created_at":"2014-04-08T23:45:05.576Z","description":"PepsiCo Welch\'s Grape Soda – Packungsgröße: 24er Pack","order_number":"SBS-0009C","price":{"gross":25.5,"currency":"EUR","net":21.43,"tax_rate":0.19,"tax":4.07},"product_id":"53448a00417175b106450000","qty":2,"requires_shipment":true,"total":{"gross":51.0,"currency":"EUR","net":42.86,"tax_rate":0.19,"tax":8.14},"total_weight":12.0,"unit":"Pack","updated_at":"2014-04-08T23:45:05.576Z","variant_id":"53448a00417175b1064a0000","weight":6.0},{"_id":"53448a01417175b106ef0000","created_at":"2014-04-08T23:45:05.576Z","description":"Branston Relish – Geschmack: Chili \u0026 Jalapeño","order_number":"SBS-0010B","price":{"gross":9.99,"currency":"EUR","net":8.39,"tax_rate":0.19,"tax":1.6},"product_id":"53448a00417175b1064c0000","qty":2,"requires_shipment":true,"total":{"gross":19.98,"currency":"EUR","net":16.79,"tax_rate":0.19,"tax":3.19},"total_weight":1.0,"unit":"Tube","updated_at":"2014-04-08T23:45:05.576Z","variant_id":"53448a00417175b1064f0000","weight":0.5},{"_id":"53448a01417175b106f00000","created_at":"2014-04-08T23:45:05.576Z","description":"PepsiCo Pepsi Cola – Packungsgröße: 6er Pack, Geschmack: Diet","order_number":"SBS-0007A","price":{"gross":5.99,"currency":"EUR","net":5.03,"tax_rate":0.19,"tax":0.96},"product_id":"53448a00417175b1062b0000","qty":1,"requires_shipment":true,"total":{"gross":5.99,"currency":"EUR","net":5.03,"tax_rate":0.19,"tax":0.96},"total_weight":1.75,"unit":"Pack","updated_at":"2014-04-08T23:45:05.576Z","variant_id":"53448a00417175b1062c0000","weight":1.75},{"_id":"53448a01417175b106f10000","created_at":"2014-04-08T23:45:05.577Z","description":"Heinz Tomato Ketchup – Größe: Groß (500g)","order_number":"SBS-0012B","price":{"gross":5.5,"currency":"EUR","net":4.62,"tax_rate":0.19,"tax":0.88},"product_id":"53448a00417175b106530000","qty":2,"requires_shipment":true,"total":{"gross":11.0,"currency":"EUR","net":9.24,"tax_rate":0.19,"tax":1.76},"total_weight":1.0,"unit":"Glas","updated_at":"2014-04-08T23:45:05.577Z","variant_id":"53448a00417175b106560000","weight":0.5},{"_id":"53448a01417175b106f20000","created_at":"2014-04-08T23:45:05.577Z","description":"PepsiCo Pepsi Cola – Packungsgröße: 24er Pack, Geschmack: Wild Cherry","order_number":"SBS-0007F","price":{"gross":15.99,"currency":"EUR","net":13.44,"tax_rate":0.19,"tax":2.55},"product_id":"53448a00417175b1062b0000","qty":2,"requires_shipment":true,"total":{"gross":31.98,"currency":"EUR","net":26.87,"tax_rate":0.19,"tax":5.11},"total_weight":12.0,"unit":"Pack","updated_at":"2014-04-08T23:45:05.577Z","variant_id":"53448a00417175b1063b0000","weight":6.0},{"_id":"53448a01417175b106f30000","created_at":"2014-04-08T23:45:05.577Z","description":"PepsiCo Mountain Dew – Packungsgröße: 12er Pack","order_number":"SBS-0008B","price":{"gross":15.5,"currency":"EUR","net":13.03,"tax_rate":0.19,"tax":2.47},"product_id":"53448a00417175b1063e0000","qty":5,"requires_shipment":true,"total":{"gross":77.5,"currency":"EUR","net":65.13,"tax_rate":0.19,"tax":12.37},"total_weight":null,"unit":"Pack","updated_at":"2014-04-08T23:45:05.577Z","variant_id":"53448a00417175b106410000","weight":null}],"merchant_id":"534489ff417175b106000000","number":"14521135","paid_email_callback_url":"http://burger-store.dev/mails/paid_notification","payment_costs":null,"payment_means":{"_id":"53448a07417175b1064a0400","created_at":"2014-04-08T23:45:11.731Z","kind":"Cash","paid_at":"2014-04-08T23:45:19+00:00","refunded_at":null,"updated_at":"2014-04-08T23:45:19.468Z"},"placed_at":"2014-04-08T09:34:57+00:00","placed_email_callback_url":"http://burger-store.dev/mails/placed_notification","reference":"13d583c4340d9bfe52aa1f7cb92735c5f5b748135f170b4d5cd752c9fd25f149","requested_carrier":{"name":"UPS","service":"Express","supports_cod":false},"sales_tax":null,"shipments":[{"_id":"53448a0c417175b106bc0400","carrier":{"name":"UPS","service":"Express","supports_cod":false},"created_at":"2014-04-08T23:45:16.196Z","shipped_items":["53448a01417175b106ed0000","53448a01417175b106ee0000","53448a01417175b106ef0000","53448a01417175b106f00000","53448a01417175b106f10000","53448a01417175b106f20000","53448a01417175b106f30000"],"tracking_number":"DXD993882F","updated_at":"2014-04-08T23:45:16.196Z"}],"shipped_email_callback_url":"http://burger-store.dev/mails/shipped_notification","shipping_address":{"_id":"53448a05417175b1069d0300","addition":null,"company":"Osinski-Bradtke","country":"United States","firstname":"Clara","name":"Volkman","number":"634","state":"Florida","street":"Lind Mount","town":"New Demario","zip":"95413"},"shipping_costs":{"gross":78.99,"currency":"EUR","net":66.38,"tax_rate":0.19,"tax":12.61},"subtotal":{"gross":274.95,"currency":"EUR","net":231.05,"tax_rate":0.19,"tax":43.9},"success_redirect_url":"http://burger-store.dev/carts/success","total":{"gross":353.94,"currency":"EUR","net":297.43,"tax_rate":0.19,"tax":56.51},"updated_at":"2014-04-08T23:45:13.562Z","weight":42.75,"customer":{"_id":"53448a05417175b1069f0300","allows_marketing":false,"created_at":"2014-04-08T23:45:09.148Z","email":"brycen_hauck@reynolds.name","flagged":false,"merchant_id":"534489ff417175b106000000","phone":null,"tax_number":null,"updated_at":"2014-04-08T23:45:09.148Z"}}'
    @order = Cornerstore::Order.new(JSON.parse(json))
  end

  context 'regarding basic attributes' do
    it 'should correctly return basic attributes' do
      expect(@order.id).to eq('53448a01417175b106ec0000')
      expect(@order.number).to eq('14521135')
      expect(@order.reference).to eq('13d583c4340d9bfe52aa1f7cb92735c5f5b748135f170b4d5cd752c9fd25f149')
      expect(@order.weight).to eq(42.75)
    end

    it 'should return the prices' do
      expect(@order.subtotal.amount).to eq(274.95)
      expect(@order.shipping_costs.amount).to eq(78.99)
      expect(@order.payment_costs).to eq(nil)
      expect(@order.sales_tax).to eq(nil)
      expect(@order.total.amount).to eq(353.94)
    end

    it 'should return the requested carrier' do
      expect(@order.requested_carrier.name).to eq('UPS')
      expect(@order.requested_carrier.service).to eq('Express')
    end
  end

  context 'regarding associated objects' do
    it 'should return the customer' do
      expect(@order.customer.class).to eq(Cornerstore::Customer)
      expect(@order.customer.email).to eq('brycen_hauck@reynolds.name')
    end

    it 'should return a billing address' do
      expect(@order.billing_address.class).to eq(Cornerstore::Address)
      expect(@order.billing_address.name).to eq('Bailey')
      expect(@order.billing_address.firstname).to eq('Ellis')
      expect(@order.billing_address.number).to eq('441')
      expect(@order.billing_address.street).to eq('Karli View')
      expect(@order.billing_address.town).to eq('North Penelope')
      expect(@order.billing_address.country).to eq('United States')
    end

    it 'should return a shipping address' do
      expect(@order.billing_address.class).to eq(Cornerstore::Address)
    end

    it 'should return the line items' do
      expect(@order.line_items.count).to eq(7)
      expect(@order.line_items.first.description).to eq('PepsiCo Welch\'s Grape Soda – Packungsgröße: 12er Pack')
      expect(@order.line_items.first.qty).to eq(5)
      expect(@order.line_items.first.weight).to eq(3.0)
      expect(@order.line_items.first.price.amount).to eq(15.50)
      expect(@order.line_items.first.total.amount).to eq(15.50 * 5)
    end

    it 'should return shipments and shipped line items' do
      expect(@order.completely_shipped?).to eq(true)
      expect(@order.shipments.first.line_items.count).to eq(@order.line_items.count)
      expect(@order.shipments.first.tracking_number).to eq('DXD993882F')
      expect(@order.shipments.first.carrier.name).to eq('UPS')
      expect(@order.shipments.first.carrier.service).to eq('Express')
    end

    it 'should return cancellations and canceled line items' do
      expect(@order.completely_canceled?).to eq(false)
      expect(@order.cancellations.first).to eq(nil)
    end

    it 'should return payment means' do
      expect(@order.payment_means.class).to eq(Cornerstore::PaymentMeans)
      expect(@order.payment_means.kind).to eq('Cash')
    end
  end
end