require 'rubygems'
require 'bundler'
Bundler.require
require 'csv'
require 'open-uri'
require 'kconv'

class MangaParser
  def initialize
    @user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/46.0.2490.86 Safari/537.36'
  end

  def main
    CSV.open("./level2_result.tsv", 'w', col_sep: "\t") do |tsv|
      manga_data = CSV.table("./level1_result.tsv", col_sep: "\t")
      tsv.puts add_header manga_data
      manga_data.each do |data|
        if data[:mangapedia_title_url].nil?
          tsv.puts data
        else
          mangapedia_author_url = get_mangapedia_author_url data
          awards_of_author = get_awards_of_author mangapedia_author_url
          tsv.puts data.to_h.values.push mangapedia_author_url, awards_of_author
        end
      end
    end
  end

  def add_header(manga_data)
    manga_data.headers.push(:mangapedia_author_url, :awards_of_author)
  end

  def get_mangapedia_author_url(data)
    parsed_title_url = visit data[:mangapedia_title_url]
    title_url_elements = get_elements(parsed_title_url, "//dl[@class='dl1']//a[@itemprop='url']")
    'https://mangapedia.com' + title_url_elements.first.attributes["href"].value
  end

  def get_awards_of_author(mangapedia_author_url)
    awards = []
    parsed_author_url = visit mangapedia_author_url
    author_url_elements = get_elements(parsed_author_url, "//div[@class='cont']//td[@itemprop='award']")
    author_url_elements.each {|f| awards << f.text}
    awards.join(',').gsub(/\n/, '').gsub(" ", "")
  end

  def visit(url)
    html = open(url, 'r:binary', 'User-Agent' => @user_agent).base_uri.read
    parsed_html = Nokogiri::HTML.parse(html.toutf8, nil, 'utf-8')
  end

  def get_elements(parsed_html, path)
    parsed_html.xpath(path)
  end
end

crawler = MangaParser.new
crawler.main
