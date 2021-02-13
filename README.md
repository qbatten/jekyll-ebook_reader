# Jekyll-EbookReader

This plugin allows you to embed eBooks in your site on any page or post!

It uses [EPUB.js](http://futurepress.org/) to do so.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-ebook_reader'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll-ebook_reader

## Usage

To embed a book on a page/post:
1. Add your ebook file to your `/assets` folder. Take note of the path to your book, starting at the base of your site. (E.g. it may be '/assets/myBook.epub', or if you put it inside an "ebooks" subfolder, it might be 'assets/ebooks/myBook.epub'.)
2. Go to the page you want to embed it on and
    a. add an 'ebook_path' variable to your front matter.
    b. add an `{% ebook %}` tag wherever you'd like the book to appear.
That's it!

For example, if you wanted to embed Moby Dick on a page, you could add MobyDick.epub to your assets folder, and then make a page that looks like this:

```
---
layout: default
title:  "EbookExample"
date:   2021-02-12 15:01:30 -0500 
ebook_path: "/assets/MobyDick.epub"
---

Gosh this is my favorite book!!

{% ebook %}

```



## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/qbatten/jekyll-ebook_reader.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
