require_relative 'html_fetcher'
require_relative 'aggregator/sevennet'
require_relative 'aggregator/toysrus'
require_relative 'aggregator/yodobashi'

module DXYokaiWatch
  class Aggregator
    def self.get_stock_informations
      [
        ToySrus.get_stock_information,
        SevenNet.get_stock_information,
        Yodobashi.get_stock_information,
      ].flatten
    end
  end
end
