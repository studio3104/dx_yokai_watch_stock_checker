module DXYokaiWatch
  class Aggregator
    class SevenNet
      PRODUCT_PAGE_URL = 'http://www.7netshopping.jp/hobby/detail/-/accd/2110353225/subno/1'

      def self.aggregator
        @aggregator ||= DXYokaiWatch::HTMLFetcher.new(PRODUCT_PAGE_URL)
      end

      def self.get_stock_information
        nokogiri = aggregator.parsed_html()

        img_url_nokogiri = nokogiri.css('div#main > a > img').first
        img_url = img_url_nokogiri ? img_url_nokogiri['src'] : nil

        price = nokogiri.css('p.detail_item_price > span.detail_item_secondary_status').text
        price = price.empty? ? nil : price.gsub(/[^\d]/, '').to_i

        stocked = case nokogiri.css('p.detail_item_ship > span.detail_item_secondary_status').text
                  when '', /品切れ/
                    false
                  else
                    true
                  end

        [{
          img_url: img_url,
          store_name: 'セブンネットショッピング',
          store_url: PRODUCT_PAGE_URL,
          price: price,
          stocked: stocked,
        }]
      end
    end
  end
end
