# 青空文庫 Scraper

Example: 太宰治

```sh
$ bundle exec ruby list_xhtml_urls_from_author_page.rb https://www.aozora.gr.jp/index_pages/person35.html > tmp/dazai_urls.txt
```

```sh
$ cat tmp/dazai_urls.txt | bundle exec ruby collect_articles_as_json.rb > tmp/dazai.json
```
