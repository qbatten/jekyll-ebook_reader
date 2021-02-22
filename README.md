# Jekyll-EbookReader

This plugin allows you to embed eBooks in your site on any page or post!

It uses [EPUB.js](http://futurepress.org/) to do so.

You can see a [live demo here](https://www.quinnbatten.com/jekyll-ebook-reader-example.html) as well!

## Installation

You need to have Jekyll installed, of course, and have your Jekyll site all set up. If you haven't used plugins with Jekyll before, you should read [their docs on plugins](https://jekyllrb.com/docs/plugins/).

Add this line to your site's Gemfile:

```ruby
gem 'jekyll-ebook_reader'
```

Then, go to your _config.yml, and addthe following (of course if you have a plugins item, just append the ebookreader line to it.)

```yaml
plugins:
  - jekyll/ebook_reader
```

*BIG IMPORTANT NOTE:* Make sure you insert that exact line! It's not `- jekyll-ebook_reader`, nor is it `- ebook_reader`, those won't work.

And then execute:

    $ bundle install

Now you should be good to go!

# Usage

## Quickstart

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


## Troubleshooting & Contributing

Bug reports and pull requests are welcome on GitHub at [github.com/qbatten/jekyll-ebook_reader](https://github.com/qbatten/jekyll-ebook_reader).

## Acknowledgments & License

EPUB.js is an awesome library and you should check them out! This plugin is really just a simple wrapper around their hypothesis-reader library that makes it easy to use with Jekyll. The JavaScript code used here is based closely on epubjs's demo code, with some small changes made for aesthetics and compatibility with the layout I chose. 

See LICENSE.md for details on licensing.

