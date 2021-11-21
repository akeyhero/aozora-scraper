#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

arg_author_page_url = ARGV[0]
unless arg_author_page_url
  raise ArgumentError, 'Pass an author page URL (e.g. https://www.aozora.gr.jp/index_pages/person35.html)'
end

author_page_uri = URI.parse(arg_author_page_url)

charset, html = author_page_uri.open { |f| [f.charset, f.read] }
page = Nokogiri::HTML.parse(html, nil, charset)

card_uris = page.search('body > ol > li')
                .filter_map { |item| item.at('a') }
                .map { |anchor| author_page_uri + anchor.attr('href') }

card_uris.each do |card_uri|
  sleep rand(1..5)

  card_charset, card_html = card_uri.open { |f| [f.charset, f.read] }
  card_page = Nokogiri::HTML.parse(card_html, nil, card_charset)

  anchor = card_page.xpath("//a[text()='いますぐXHTML版で読む']").first
  unless anchor
    STDERR.puts("WARNING: target URL not found in #{card_uri}")
    next
  end
  puts card_uri + anchor.attr('href')
  STDOUT.flush
end
