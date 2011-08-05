class StocksController < AuthorizedController
  # States
  has_scope :by_state, :default => 'available', :only => :index
  has_scope :by_text

  # Actions
  def new

    # Defaults
    stock_params = {
      :state  => 'available'
    }

    # Load and assign parent invoice
    if params[:invoice_id]
      invoice = Invoice.find(params[:invoice_id])
      stock_params.merge!(
        :title  => invoice.title,
        :amount => invoice.amount
      )
    end

    # Paramameters
    stock_params.merge!(params[:stock] || {})

    @stock = Stock.new(stock_params)
  end

  def create
    @stock = Stock.new(params[:stock])
    @stock.build_booking

    create!
  end

  def write_downs
    # use current date if not specified otherwise
    if params[:by_value_period]
      @end_date = Date.parse(params[:by_value_period][:to])
      @start_date = Date.parse(params[:by_value_period][:from])
    else
      @end_date = Date.today
      @start_date = @end_date.to_time.advance(:years => -1, :days => 1).to_date
    end

    @date = @start_date..@end_date

    @stocks = Stock.all
    @stocks = @stocks.select{|stock|
      stock.balance(@start_date) != 0.0 or stock.balance(@end_date) != 0.0
    }
  end
end
