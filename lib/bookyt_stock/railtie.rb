require 'bookyt_stock'
require 'rails'

module BookytStock
  class Railtie < Rails::Engine
    config.to_prepare do
      ::Invoice.send :include, BookytStock::Invoice
    end
  end
end
