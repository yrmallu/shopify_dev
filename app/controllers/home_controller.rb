class HomeController < ShopifyApp::AuthenticatedController
  skip_before_action :verify_authenticity_token, only: :update_order_details, raise: false

  def index
  end

end
