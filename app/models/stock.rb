class Stock < ApplicationRecord
  has_many :user_stocks
  has_many :users, through: :user_stocks

  def self.find_by_ticker(ticker_symbol)
    where(ticker: ticker_symbol).first
  end

  def self.new_from_lookup(ticker_symbol)
    begin
      looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
      new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.company_name, last_price: looked_up_stock.latest_price)
    rescue Exception => e
      return nil
    end
  end

  def price
    closing_price = StockQuote::Stock.quote(ticker).l
    return "#{closing_price} (Closing)" if closing_price
    opening_price = StockQuote::Stock.quote(ticker).op
    return "#{opening_price} (Opening)" if opening_price
    'Unavailable'
  end
end
