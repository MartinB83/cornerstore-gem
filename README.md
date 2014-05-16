# Cornerstore

This is a client for the Cornerstore API-based online shop. Cornerstore allows you to create custom online shops
with your own front-end code, platform and tool belt choices. Instead of reinventing the wheel however, Cornerstore will
supply you with common e-commerce resources like products and carts via API. It also includes a checkout and Manager interface,
so your customers can manage their products and orders without you having to code yet another admin back-end.

Learn more about Cornerstore at http://www.cornerstore.io and http://addons.heroku.com/cornerstore

## Authentication

The gem tries to retrieve your Cornerstore credentials in the following order:

1. It checks if the env variable CORNERSTORE_URL is set and extracts the credentials. If you provisioned
with Heroku this variable is already configured.

2. If no env variable is available it checks the secrets.yml file on Rails 4.1 or looks for a
cornerstore.yml on previous versions. See examples/cornerstore.yml for an example.

3. You can always set the credentials directly by using the Cornerstore.subdomain= and Cornerstore.api_key=
methods.

## Getting products & collections

You can retrieve products from Cornerstore like so:

    product = Cornerstore::Product.find('sugo-al-basilico')
    product.manufacturer #=> "Fattoria Croccante"
    
    product = Cornerstore::Product.find('5900338280000393023')
    product.name #=> "Sugo Al Basilico"

    collection = Cornerstore::Collection.find('spaghetti').child_collections.first
    product = collection.products.first
    product.variants.any? #=> true
    product.variants.first.price.decimal_amount #=> 12.99
    
## Creating carts and adding line items

You can create carts and handle line items as state below. Line items can either be created from scratch or you can
derive them from a product/variant.

    cart = Cornerstore::Cart.new({
        success_redirect_url: "http://yourshop.com/cart/success",
        cart_url:             "http://yourshop.com/cart"
    })
    
    product = Cornerstore::Product.find('sugo-al-basilico')
    variant = product.variants.find('SBS-39993')
    
    # Derive from variant
    cart.line_items.create_from_variant(variant, qty: 10)
    
    line_item = cart.line_items.first
    line_item.qty = 15
    line_item.save
    
    another_line_item = cart.line_items.last
    another_line_item.destroy
    
    # Create a line item directly
    line_item = Cornerstore::LineItem.create({
        qty: 10,
        description: 'My own custom line item',
        unit: 'Piece',
        weight: 0.5,
        price: Cornerstore::Price.new(12.99, 'USD')
    })

## Learn more

We provide a full API documentation at http://developer.cornerstore.io/api, including many ruby examples. Generally every
attribute that is listed in the API docs corresponds to a ruby method that can be called on the respective objects. In
many cases there are additional methods available, just check out the classes of this gem and our Rails example store
and boilerplate at https://github.com/crispymtn/fattoria-croccante.