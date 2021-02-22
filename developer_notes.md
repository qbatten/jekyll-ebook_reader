# Developer Notes

These are just some working notes that I'm keeping for myself. Feel free to have a look if you like but they're really just for me. (Although if you see something incorrect in here and feel like taking some time to write an issue that's totally cool too!)

## To deploy:

* First, bump version in version.rb. 
* Then run `rake` to check for errors.
* Then build and push to RubyGems:

```
export tmp_jekyll_ebook_gem_version=0.1.2

gem build jekyll-ebook_reader.gemspec
gem push jekyll-ebook_reader-${tmp_jekyll_ebook_gem_version}.gem
```

* Now git add, git commit, git push
* And make a releasee on Github

## Links

* https://medium.com/@SunnyB/my-first-ruby-gem-part-2-a-look-under-the-hood-efe4a68ba42