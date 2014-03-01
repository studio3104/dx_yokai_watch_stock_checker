module DXYokaiWatch
  class Aggregator
    class Yodobashi
      STOCK_CHECK_URL = 'http://www.yodobashi.com/ec/product/stock/100000001002065181/index.html?popup=1'
      PRODUCT_PAGE_URL = 'http://www.yodobashi.com/%E3%83%90%E3%83%B3%E3%83%80%E3%82%A4-%E5%A6%96%E6%80%AA%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81-DX%E5%A6%96%E6%80%AA%E3%82%A6%E3%82%A9%E3%83%83%E3%83%81-%E8%85%95%E6%99%82%E8%A8%88%E5%9E%8B%E7%8E%A9%E5%85%B7/pd/100000001002065181/'

      def self.aggregator
        @aggregator ||= []
        @aggregator[0] ||= DXYokaiWatch::HTMLFetcher.new(STOCK_CHECK_URL)
        @aggregator[1] ||= DXYokaiWatch::HTMLFetcher.new(PRODUCT_PAGE_URL)
        @aggregator
      end

      def self.get_stock_information
        stock_check = aggregator[0].parsed_html()
        img_url_nokogiri = stock_check.css('div.pImg > img').first
        img_url = img_url_nokogiri ? img_url_nokogiri['src'] : nil

        product_page = aggregator[1].parsed_html()
        price = product_page.css('strong#js_scl_unitPrice').text
        price = price.empty? ? nil : price.gsub(/[^\d]/, '').to_i

        stock_information = stock_check.css('div.storeInfoUnit').map do |elm|
          store_url_nokogiri = elm.css('a').first
          store_url = store_url_nokogiri ? store_url_nokogiri['href'] : PRODUCT_PAGE_URL

          {
            img_url: img_url,
            store_name: 'ヨドバシカメラ ' + elm.css('div.storeName').text,
            store_url: store_url,
            price: price,
            stocked: elm.css('span.uiIconTxtS').text == '在庫なし' ? false : true,
          }
        end

        stock_information.reverse
      end
    end
  end
end
