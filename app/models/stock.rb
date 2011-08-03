class Stock < ActiveRecord::Base
  # Invoices
  belongs_to :purchase_invoice, :class_name => 'Invoice'
  belongs_to :selling_invoice, :class_name => 'Invoice'

  # Validations
  validates_presence_of :title, :amount, :state

  # String
  def to_s(format = :default)
    title
  end

  # Search
  # ======
  scope :by_text, lambda {|value|
    text   = '%' + value + '%'

    amount = value.delete("'").to_f
    if amount == 0.0
      amount = nil unless value.match(/^[0.]*$/)
    end

    date   = nil
    begin
      date = Date.parse(value)
    rescue ArgumentError
    end

    includes(:purchase_invoice, :selling_invoice).where("stocks.title LIKE :text OR stocks.remarks LIKE :text OR stocks.amount = :amount OR date(invoices.value_date) = :date", :text => text, :amount => amount, :date => date)
  }

  # States
  # ======
  STATES = ['available', 'amortized', 'sold', 'removed']
  scope :by_state, lambda {|value|
    where(:state => value) unless value == 'all'
  }

  # Period
  # ======
  scope :active_at, lambda {|value| bookings.balance(value) == 0}

  # Bookings
  # ========
  include HasAccounts::Model

  # Guess direct_account
  #
  # We simply take the first booking and exclude accounts with codes
  # 1100 and 2000 (credit and debit invoices) as candidates.
  def direct_account
    # We don't care if no bookings
    return nil if bookings.empty?

    # Take any booking
    booking = bookings.first
    involved_accounts = [booking.credit_account, booking.debit_account]

    relevant_account = involved_accounts - [Account.find_by_code("1100"), Account.find_by_code("2000")]

    return relevant_account.first
  end

  # Build booking
  #
  # We use the value_date of the purchase invoice but our own amount.
  def build_booking(params = {}, template_code = nil)
    template_code = self.class.to_s.underscore + ':activate'

    # Prepare booking parameters
    booking_params = {:amount => amount}
    if purchase_invoice
      booking_params[:value_date] = purchase_invoice.value_date
    else
      booking_params[:value_date] = Date.today
    end
    booking_params.merge!(params)

    # Build and assign booking
    super(booking_params, template_code)
  end

  # Calculations
  def write_downs(value_date)
    bookings.direct_balance(value_date, Account.find_by_code('6900'))
  end

  def amount_changes(value_date)
    -(balance(value_date.first) - balance(value_date.last) - write_downs(value_date))
  end
end
