require 'spec_helper'
require './manga_parser.rb'

RSpec.describe 'MangaParser' do
  before do
    crawler = MangaParser.new
    crawler.main
    @result_tsv = CSV.table('level2_result.tsv', col_sep: "\t")
  end
  it 'ヘッダーが正しく追加されていること' do
    expect(@result_tsv.headers).to be_include :mangapedia_author_url
    expect(@result_tsv.headers).to be_include :awards_of_author
  end

  it '最初の著者のURLが正しいこと' do
    expect(@result_tsv[:mangapedia_author_url].first).to eq 'https://mangapedia.com/%E5%8E%9F%E6%B3%B0%E4%B9%85-dw316etca'
  end

  it '最後の著者のURLが正しいこと' do
    expect(@result_tsv[:mangapedia_author_url].last).to eq 'https://mangapedia.com/%E4%BD%90%E9%87%8E%E8%8F%9C%E8%A6%8B-ge6a502ff'
  end

  it '最初の著者の受賞が正しいこと' do
    expect(@result_tsv[:awards_of_author].first).to eq '第17回 手塚治虫文化賞 マンガ大賞'
  end

  it '最後の著者の受賞が正しいこと' do
    expect(@result_tsv[:awards_of_author].last).to eq ''
  end
end
