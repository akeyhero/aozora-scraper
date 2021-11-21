#!/usr/bin/env ruby
# frozen_string_literal: true

require 'open-uri'
require 'nkf'
require 'json'
require 'nokogiri'

KEYS = %w[title author bibliographical_information notation_notes]

# fix encoding since f.charset says 'UTF-8' while it should be 'Shift_JIS'
def to_utf8(text)
  text && NKF.nkf('-wLu', text)
end

STDIN.each_line do |url|
  sleep rand(1..5)
  uri = URI.parse(url.strip)
  charset, html = uri.open { |f| [f.charset, f.read] }
  page = Nokogiri::HTML.parse(html, nil, charset)
  main_text = page.at('.main_text')
  main_text.search('rp, rt').remove
  json = {
    'url' => uri,
    'main_text' => to_utf8(main_text.text).strip,
    **KEYS.to_h { |key| [key, to_utf8(page.at(".#{key}")&.text)&.strip] }
  }
  puts JSON.dump(json)
  STDOUT.flush
end
