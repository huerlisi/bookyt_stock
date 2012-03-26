module BookytStock
  module Navigation
    def setup_bookyt_stock(navigation)
      navigation.item :stocks, t_title(:index, Stock), '#',
                   :if => Proc.new { user_signed_in? } do |stocks|
        stocks.item :stock_list, t_title(:index, Stock), stocks_path, :highlights_on => /\/stocks($|\/[0-9]*($|\/.*))/
        stocks.item :new_stock, t_title(:new, Stock), new_stock_path
        stocks.item :write_downs, t_title(:write_downs, Stock), write_downs_stocks_path, :highlights_on => /\/stocks\/write_downs($|\?)/
      end
    end
  end
end
