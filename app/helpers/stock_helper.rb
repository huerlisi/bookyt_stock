module StockHelper
  # Translate stock state
  def t_stock_state(state)
    t(state, :scope => 'stock.state')
  end

  # Provide translated stock states for select fields
  def stock_states_as_collection
    states = Stock::STATES
    states.inject({}) do |result, state|
      result[t_stock_state(state)] = state
      result
    end
  end
end
