require "imgix"
require "uri"

module Jekyll
  module ZimgTagFilter
    def zimg_tag(img_url)
      # imgix_opts
      widths = [320, 420, 520, 620, 720]
      srcset_strs = []
      srcset_url = nil
      img_url = URI::encode(img_url)
      sizes = "(min-width: 720px) 720px, 100vw"
      for width in widths do
        opts = {
          :w => width,
          :fit => "max",
          :auto => "format",
          :q => 80
        }
        srcset_url = imgix_url(img_url, opts)
        srcset_strs << "#{srcset_url} #{width}w"
      end

      "<img srcset=\"#{srcset_strs.join(", ")}\" sizes=\"#{sizes}\" src=\"#{srcset_url}\">"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ZimgTagFilter)
