# frozen_string_literal: true

require_relative "lib/jekyll/ebook_reader/version"

Gem::Specification.new do |spec|
  spec.name          = "jekyll-ebook_reader"
  spec.version       = Jekyll::EbookReader::VERSION
  spec.authors       = ["Quinn Batten"]
  spec.email         = ["quinnbatten@mac.com"]

  spec.summary       = "Plugin to embed ebooks in your site."
  spec.description   = "Easily embed ebooks on any page or post in your Jekyll site. "\
                       "See the README for detailed installation and usage info: "\
                       "https://github.com/qbatten/jekyll-ebook_reader"
  spec.homepage      = "https://github.com/qbatten/jekyll-ebook_reader"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/qbatten/jekyll-ebook_reader.git"
  spec.metadata["changelog_uri"] = "https://github.com/qbatten/jekyll-ebook_reader/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "fileutils", ">= 1.1.0", "<= 1.5.0"
  spec.add_dependency "jekyll", ">= 3.0", "< 5.0"

  spec.add_development_dependency "bundler", ">= 1.17.2", "<= 2.2.12"
  spec.add_development_dependency "rubocop-rake", ">=0.1.1", "<= 0.5.1"
end
