ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "a4f6725c797ab3df754fa8cfe625b233"
  config.secret = "26454a5cd590d2de9da2ae392c716fe6"
  config.scope = "read_products, read_orders, read_customers, write_orders, read_shipping, write_shipping, read_fulfillments, write_fulfillments" # Consult this page for more scope options:
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
