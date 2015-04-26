require 'nokogiri'
require 'open-uri'

class ClickBD

    def initialize
        @site = 'http://www.clickbd.com'
        @endpoint = @site + '/search/price-from/1/page/'
        @paginate = 30
        @current_page = 0
    end

    def get_page_html
        Nokogiri::HTML(open(url))
    end

    def listing
        get_page_html.css('div.sh')
    end

    def items
        items = []
        listing.each do |item|
            next if duplicate item
            items << get_hash(item) 
        end

        items
    end

    private

    def url
        start = @paginate * (@current_page)
        @current_page += 1

        @endpoint + start.to_s
    end

    def get_id item
        link = get_link item
        link['href'].scan(/\/bangladesh\/(\d+)-/)[0][0].to_i
    end

    def get_link item
        item.css('h3 a').first
    end

    def duplicate item
        id = get_id(item)
        false
    end

    def get_hash item
        link = get_link item
        id = get_id item
        img = item.at_css('div.img img')['src']
        price = item.at_css('div.rt > b > b').inner_text.gsub(',', '').to_i

        {
            :title      => link['title'],
            :url        => @site + link['href'],
            :clickbd_id => id,
            :image      => img,
            :price      => price,
        }
    end

end
