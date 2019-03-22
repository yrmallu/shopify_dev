class HomeController < ShopifyApp::AuthenticatedController
  skip_before_action :verify_authenticity_token, only: :update_order_details, raise: false

  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @orders = ShopifyAPI::Order.find(:all, params: { limit: 10 })
    @customers = ShopifyAPI::Customer.find(:all, params: { limit: 10 })
  end

  def get_order
    @order = ShopifyAPI::Order.find(params['id'])
  end

  def update_order_details
    order = ShopifyAPI::Order.find(params[:order][:order_id])
    order.shipping_address = params[:order].as_json
    order.save
    if params[:order][:tracking_number].present?
      order.fulfillments.first.update_attributes(order_id: order.id, tracking_numbers: [params[:order][:tracking_number]])
    end
    redirect_to action: 'index'
  end

  def profit_details
    profit_datapoints = [["00:00", 0]]
    start_time = Time.now.midnight
    for i in 1..23
      end_time = start_time + i.hour
      total_revenue = ShopifyAPI::Order.where(created_at_min: start_time, created_at_max: end_time).map{|a| a.total_price.to_f }.sum.round
      supplier_cost = (total_revenue * 0.2).round
      marketing_cost = (total_revenue * 0.4).round
      profit = (i-1) < Time.now.strftime("%H").to_i ? (total_revenue - supplier_cost - marketing_cost) : ''
      # profit = total_revenue - supplier_cost - marketing_cost
      profit_datapoints << [end_time.strftime("%H:00"), profit]
    end
    render json: profit_datapoints
  end

end
