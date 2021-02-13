require "fileutils"
require "jekyll"


module Jekyll
  module EbookReader
    class EbookEmbed < Jekyll::Generator
      safe false
      priority :low
      def generate(site)
        @site = site
        @site = site.static_files += add_all_static_files

      end

      private 

      # Destination for sitemap.xml file within the site source directory
      def destination_path(file)
        @site.in_dest_dir("/assets/jekyll-ebookreader/#{file}")
      end

      def static_files_to_include
        ["reader.js" , "ebookreader_main.css", "ebookreader_iframe.css", "ajax-loader.gif"]
      end

      def add_all_static_files
        files ||= []
        static_files_to_include.each do |file_name|
          incl = Jekyll::StaticFile.new(@site, File.join( File.dirname(__FILE__), 'ebook_reader'), "assets/jekyll-ebookreader-assets", file_name)
          incl.destination(destination_path(file_name))
          files.append(incl)
        end
        files
      end
    end

  end
end


class EBookReaderTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
    @input = input
  end

  def render(context)
    path = File.join(File.dirname(__FILE__), 'ebook_reader', "assets/jekyll-ebookreader-assets/ebook_include_body_tag.html")
    include_string = File.read(path)
    processed = Liquid::Template.parse(include_string).render(context)
    return processed
  end
end

    # Add relevant scripts and style tags to doc head
Jekyll::Hooks.register [:pages, :posts], :post_render do |post|
  path = File.join(File.dirname(__FILE__), 'ebook_reader', "assets/jekyll-ebookreader-assets/ebook_include_header.html")
  include_string = File.read(path)

  if post.data.has_key? ("ebook_path")
    post.output = post.output.gsub("</head>", include_string + "</head>")
  end
end

Liquid::Template.register_tag('ebook', EBookReaderTag)