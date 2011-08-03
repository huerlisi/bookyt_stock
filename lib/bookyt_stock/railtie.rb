require 'bookyt_stock'
require 'rails'

module BookytStock
  class Railtie < Rails::Engine
    initializer :after_initialize do |app|
      app.config.bookyt.engines << 'bookyt_stock'
    end
  end
end
