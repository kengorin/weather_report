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
      url1 = 'http://weather.yahoo.co.jp/weather/jp/36/7110.html'
      url2 = 'http://weather.yahoo.co.jp/weather/13/4410.html'

      date_path_1 = "//*[@id=\"main\"]/div[@class='forecastCity']/table/tr/td/div/p[1]/text()"
      forecast_path_1 = "//*[@id=\"main\"]/div[@class='forecastCity']/table/tr/td/div/p[2]/text()"
      forecast_image_path_1= "//*[@id=\"main\"]/div[@class='forecastCity']/table/tr/td/div/p[2]/img"

      date_path_2 = "//*[@id=\"main\"]/div[7]/table/tr/td/div/p[1]/text()"
      forecast_path_2 = "//*[@id=\"main\"]/div[7]/table/tr/td/div/p[2]/text()"
      forecast_image_path_2= "//*[@id=\"main\"]/div[@class='forecastCity']/table/tr/td/div/p[2]/img"

      parsed_html_1 = visit(url1)
      parsed_html_2 = visit(url2)

      date1 = get_elements(parsed_html_1, date_path_1).first.to_s
      forecast1 = get_elements(parsed_html_1, forecast_path_1).first.to_s
      forecast_image_url1 = get_elements(parsed_html_1, forecast_image_path_1).first.attributes['src'].value
      date2 = get_elements(parsed_html_2, date_path_2).first.to_s
      forecast2 = get_elements(parsed_html_2, forecast_path_2).first.to_s
      forecast_image_url2 = get_elements(parsed_html_2, forecast_image_path_2).first.attributes['src'].value

      CSV.open("./weather.csv", 'w') do |csv|
        csv.puts ['日付','徳島の天気', 'お天気像url1']
        csv.puts [date1, forecast1, forecast_image_url1]
        csv.puts []
        csv.puts ['日付','東京の天気', 'お天気像url1']
        csv.puts [date2, forecast2, forecast_image_url2]
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
