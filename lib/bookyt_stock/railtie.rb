require 'bookyt_stock'
require 'rails'

module BookytStock
  class Railtie < Rails::Engine
    initializer :after_initialize do |app|
      app.config.bookyt.engines << 'bookyt_stock'
    end

    config.to_prepare do
      ::Invoice.send :include, BookytStock::Invoice
    end
  end
end
