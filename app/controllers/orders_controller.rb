class OrdersController < ShopifyApp::AuthenticatedController

  def index
    @orders = ShopifyAPI::Order.find(:all, params: { limit: 10 })
  end

  def edit
    @order = ShopifyAPI::Order.find(params['id'])
  end

  def update
    order = ShopifyAPI::Order.find(params[:shopify_api_order][:order_id])
    order.shipping_address = params[:shopify_api_order].to_unsafe_h
    order.save
    if params[:shopify_api_order][:tracking_number].present?
      order.fulfillments.first.update_attributes(order_id: order.id, tracking_numbers: [params[:shopify_api_order][:tracking_number]])
    end
    redirect_to action: 'index'
  end

  def profit_details
    data_points = [["00:00", 0]]
    start_time = Time.now.midnight
    for i in 1..23
      end_time = start_time + i.hour
      total_revenue = ShopifyAPI::Order.where(created_at_min: start_time, created_at_max: end_time).map{|a| a.total_price.to_f }.sum.round
      supplier_cost = (total_revenue * 0.2).round
      marketing_cost = (total_revenue * 0.4).round
      profit = (i-1 < Time.now.strftime("%H").to_i ) ? (total_revenue - supplier_cost - marketing_cost) : ''
      data_points << [end_time.strftime("%H:00"), profit]
    end
    render json: data_points
  end

 end
