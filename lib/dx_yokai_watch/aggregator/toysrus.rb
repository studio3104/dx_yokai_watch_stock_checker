module DXYokaiWatch
  class Aggregator
    class ToySrus
      PRODUCT_PAGE_URL = 'http://www.toysrus.co.jp/product/product_detail.aspx?skn=452818&pin=200&top_id=001'

      def self.aggregator
        @aggregator ||= DXYokaiWatch::HTMLFetcher.new(PRODUCT_PAGE_URL)
      end

      def self.get_stock_information
        nokogiri = aggregator.parsed_html()

        img_url_nokogiri = nokogiri.css('div#media > p#pnlProductImage > a > img').first
        img_url = if img_url_nokogiri
                    aggregator.uri.scheme + '://' + aggregator.uri.host + '/_/' + img_url_nokogiri['src']
                  else
                    nil
                  end

        price = nokogiri.css('span.price > span.price').text
        price = price.empty? ? nil : price.gsub(/[^\d]/, '').to_i

        stocked = case nokogiri.css('h5 > strong').text
                  when '', /現在、在庫がございません/
                    false
                  else
                    true
                  end

        [{
          img_url: img_url,
          store_name: 'トイザらス',
          store_url: PRODUCT_PAGE_URL,
          price: price,
          stocked: stocked,
        }]
      end
    end
  end
end
