module BookytStock
  module Invoice
    extend ActiveSupport::Concern
    
    included do
      has_many :stocks, :foreign_key => :purchase_invoice_id
    end
  end
end
   