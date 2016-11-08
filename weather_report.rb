require 'rubygems'
require 'bundler'
Bundler.require
require 'csv'
require 'open-uri'
require 'kconv'

class WeatherReport
    def initialize
      @user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'
    end

    def exec
      url = 'http://weather.yahoo.co.jp/weather/jp/36/7110.html'
      #date_path = "//*[@id=\"main\"]/div[6]/table/tbody/tr/td[1]/div/p[1]"
      forecast_path = "//*[@id=\"main\"]/div[@class='forecastCity']/table/tbody/tr/td/div/p[2]/text()"
      forecast_image_path = "//*[@id=\"main\"]/div[6]/table/tbody/tr/td[1]/div/p[2]/img"
      parsed_html = visit(url)
      #date = get_elements(parsed_html, date_path).first.to_s
      forecast = get_elements(parsed_html, forecast_path).first.to_s
      binding.pry
      forecast_image_url = get_elements(parsed_html, forecast_image_path).first.attributes['src'].value

      CSV.open("./weather.csv", 'w') do |csv|
        csv.puts ['徳島の天気', 'お天気像URL']
        csv.puts [forecast, forecast_image_url]
      end
    end

    def visit(url)
      html = open(url, 'r:binary', 'User-Agent' => @user_agent).base_uri.read
      parsed_html = Nokogiri::HTML.parse(html.toutf8, nil, 'utf-8')
    end

    def get_elements(parsed_html, path)
      parsed_html.xpath(path)
    end
end

crawler = WeatherReport.new
crawler.exec
