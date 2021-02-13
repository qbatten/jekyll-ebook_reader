require "fileutils"
require "jekyll"
require_relative "ebook_reader/version"

# module Jekyll
#   class Page
#     include Convertible

#     attr_writer :dir
#     attr_accessor :site, :pager
#     attr_accessor :name, :ext, :basename
#     attr_accessor :data, :content, :output

#     alias_method :extname, :ext

#     # Attributes for Liquid templates
#     ATTRIBUTES_FOR_LIQUID = %w(
#       content
#       dir
#       excerpt
#       name
#       path
#       url
#     ).freeze

#     # A set of extensions that are considered HTML or HTML-like so we
#     # should not alter them,  this includes .xhtml through XHTM5.

#     HTML_EXTENSIONS = %w(
#       .html
#       .xhtml
#       .htm
#     ).freeze

#     # Initialize a new Page.
#     #
#     # site - The Site object.
#     # base - The String path to the source.
#     # dir  - The String path between the source and the file.
#     # name - The String filename of the file.
#     def initialize(site, base, dir, name)
#       @site = site
#       @base = base
#       @dir  = dir
#       @name = name
#       @path = if site.in_theme_dir(base) == base # we're in a theme
#                 site.in_theme_dir(base, dir, name)
#               else
#                 site.in_source_dir(base, dir, name)
#               end

#       process(name)
#       read_yaml(PathManager.join(base, dir), name)
#       generate_excerpt if site.config["page_excerpts"]

#       data.default_proc = proc do |_, key|
#         site.frontmatter_defaults.find(relative_path, type, key)
#       end

#       Jekyll::Hooks.trigger :pages, :post_init, self
#     end

#     # The generated directory into which the page will be placed
#     # upon generation. This is derived from the permalink or, if
#     # permalink is absent, will be '/'
#     #
#     # Returns the String destination directory.
#     def dir
#       url.end_with?("/") ? url : url_dir
#     end

#     # The full path and filename of the post. Defined in the YAML of the post
#     # body.
#     #
#     # Returns the String permalink or nil if none has been set.
#     def permalink
#       data.nil? ? nil : data["permalink"]
#     end

#     # The template of the permalink.
#     #
#     # Returns the template String.
#     def template
#       if !html?
#         "/:path/:basename:output_ext"
#       elsif index?
#         "/:path/"
#       else
#         Utils.add_permalink_suffix("/:path/:basename", site.permalink_style)
#       end
#     end

#     # The generated relative url of this page. e.g. /about.html.
#     #
#     # Returns the String url.
#     def url
#       @url ||= URL.new(
#         :template     => template,
#         :placeholders => url_placeholders,
#         :permalink    => permalink
#       ).to_s
#     end

#     # Returns a hash of URL placeholder names (as symbols) mapping to the
#     # desired placeholder replacements. For details see "url.rb"
#     def url_placeholders
#       {
#         :path       => @dir,
#         :basename   => basename,
#         :output_ext => output_ext,
#       }
#     end

#     # Extract information from the page filename.
#     #
#     # name - The String filename of the page file.
#     #
#     # NOTE: `String#gsub` removes all trailing periods (in comparison to `String#chomp`)
#     # Returns nothing.
#     def process(name)
#       return unless name

#       self.ext = File.extname(name)
#       self.basename = name[0..-ext.length - 1].gsub(%r!\.*\z!, "")
#     end

#     # Add any necessary layouts to this post
#     #
#     # layouts      - The Hash of {"name" => "layout"}.
#     # site_payload - The site payload Hash.
#     #
#     # Returns String rendered page.
#     def render(layouts, site_payload)
#       site_payload["page"] = to_liquid
#       site_payload["paginator"] = pager.to_liquid

#       do_layout(site_payload, layouts)
#     end

#     # The path to the source file
#     #
#     # Returns the path to the source file
#     def path
#       data.fetch("path") { relative_path }
#     end

#     # The path to the page source file, relative to the site source
#     def relative_path
#       @relative_path ||= PathManager.join(@dir, @name).sub(%r!\A/!, "")
#     end

#     # Obtain destination path.
#     #
#     # dest - The String path to the destination dir.
#     #
#     # Returns the destination file path String.
#     def destination(dest)
#       @destination ||= {}
#       @destination[dest] ||= begin
#         path = site.in_dest_dir(dest, URL.unescape_path(url))
#         path = File.join(path, "index") if url.end_with?("/")
#         path << output_ext unless path.end_with? output_ext
#         path
#       end
#     end

#     # Returns the object as a debug String.
#     def inspect
#       "#<#{self.class} @relative_path=#{relative_path.inspect}>"
#     end

#     # Returns the Boolean of whether this Page is HTML or not.
#     def html?
#       HTML_EXTENSIONS.include?(output_ext)
#     end

#     # Returns the Boolean of whether this Page is an index file or not.
#     def index?
#       basename == "index"
#     end

#     def trigger_hooks(hook_name, *args)
#       Jekyll::Hooks.trigger :pages, hook_name, self, *args
#     end

#     def write?
#       true
#     end

#     def excerpt_separator
#       @excerpt_separator ||= (data["excerpt_separator"] || site.config["excerpt_separator"]).to_s
#     end

#     def excerpt
#       return @excerpt if defined?(@excerpt)

#       @excerpt = data["excerpt"] ? data["excerpt"].to_s : nil
#     end

#     def generate_excerpt?
#       !excerpt_separator.empty? && instance_of?(Jekyll::Page) && html?
#     end

#     private

#     def generate_excerpt
#       return unless generate_excerpt?

#       data["excerpt"] ||= Jekyll::PageExcerpt.new(self)
#     end

#     def url_dir
#       @url_dir ||= begin
#         value = File.dirname(url)
#         value.end_with?("/") ? value : "#{value}/"
#       end
#     end
#   end
# end

# module Jekyll
#   class PageWithoutAFile < Page
#     # rubocop:disable Naming/MemoizedInstanceVariableName
#     def read_yaml(*)
#       @data ||= {}
#     end
#     # rubocop:enable Naming/MemoizedInstanceVariableName
#   end
# end


      # Gather settings
      # site = context.registers[:site]
      # @settings = site.config["jekyll-ebookreader"]

      # Render any liquid variables
      # markup = Liquid::Template.parse(@markup).render(context)

      # Extract tag attributes
      # attributes = {}
      # markup.scan(Liquid::TagAttributes) do |key, value|
      #   attributes[key] = value
      # end

      # Accessing the page/site variable for the base url
      # baseurl = "#{lookup(context, 'site.baseurl')}"


      # def initialize(tagName, content, tokens)
      #   @content = content
      # end

      # # Lookup allows access to the page/post variables through the tag context
      # def lookup(context, name)
      #   lookup = context
      #   name.split(".").each { |value| lookup = lookup[value] }
      #   lookup
      # end

      # def render(context)
      #   @context = context
      #   SeoTag.template.render!(payload, info)
      # end


# DO I NEED TO ADD THIS TO THE PAGE?
# <body style ="max-width: 1200px; padding: 3%;">

class EBookReaderTag < Liquid::Tag
  def initialize(tag_name, input, tokens)
    super
    @input = input
  end

  def render(context)
    path = File.join(__dir__, "assets/jekyll-ebookreader-assets/ebook_include_body_tag.html")
    include_string = File.read(path)
    processed = Liquid::Template.parse(include_string).render(context)
    return processed
  end
end
Liquid::Template.register_tag('ebook', EBookReaderTag)

# Add relevant scripts and style tags to doc head
Jekyll::Hooks.register [:pages, :posts], :post_render do |post|
  path = File.join(__dir__, "assets/jekyll-ebookreader-assets/ebook_include_header.html")
  include_string = File.read(path)

  if post.data.has_key? ("ebook_path")
    post.output = post.output.gsub("</head>", include_string + "</head>")
  end
end


module Jekyll
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
        incl = Jekyll::StaticFile.new(@site, __dir__, "assets/jekyll-ebookreader-assets", file_name)
        incl.destination(destination_path(file_name))
        files.append(incl)
      end
      files
    end
  end
end