require 'rubygems'
require 'bundler'
Bundler.require
require 'csv'
require 'open-uri'
require 'kconv'

class WeatherReport #WeatherReportクラスの定義
    def initialize  #初期化メソッド
      @user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'
    end

    def exec


      CSV.open("./weather.csv", 'w') do |csv|

        CSV.foreach('./xpath.csv', headers: true, quote_char: "¥") do |data|  #dataの行数だけループする


            date_path_1 = data["Date_path"] #日付のXpathを代入
            forecast_path_1 = data["Forecast_path"] #予報のXpathを代入
            forecast_image_path_1= data["Forecast_Image_path"]  #画像のXpathを代入

            parsed_html_1 = visit(data["URL"]) #URL読み込み


            date1 = get_elements(parsed_html_1, date_path_1).first.to_s
            forecast1 = get_elements(parsed_html_1, forecast_path_1).first.to_s
            forecast_image_url1 = get_elements(parsed_html_1, forecast_image_path_1).first.attributes['src'].value

            csv.puts ['日付',data["City"]+"の天気", 'お天気像url1']
            csv.puts [date1, forecast1, forecast_image_url1]


        end
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
