# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

### Shops
shop = Shop.create(name: 'HelloWorld')

### Orders
order = Order.create(date: DateTime.new(2012, 8, 29, 22, 35, 0), shop_id: shop.id)

### Products
product = Product.create(name: 'milk', cost: BigDecimal('20.00'), shop_id: shop.id)

### Line Items
LineItem.create(name: product.name, cost: product.cost, quantity: 4, order_id: order.id, product_id: product.id)
