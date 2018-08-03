require "imgix"
require "uri"

module Jekyll
  module ZimgTagFilter
    def zimg_tag(img_url)
      # imgix_opts
      srcset_strs = []
      srcset_url = nil
      img_url = URI::encode(img_url)
      sizes = [
        "((min-width: 720px) and (min-resolution: 3dppx)) 2160px",
        "((min-width: 720px) and (min-resolution: 2dppx)) 1440px",
        "(min-width: 720px) 720px",
        "(min-resolution: 3dppx) 300vw",
        "(min-resolution: 2dppx) 200vw",
        "100vw"
      ]
      (400..2200).step(200) do |width|
        opts = {
          :w => width,
          :fit => "max",
          :auto => "format",
          :q => 80
        }
        srcset_url = imgix_url(img_url, opts)
        srcset_strs << "#{srcset_url} #{width}w"
      end

      "<img srcset=\"#{srcset_strs.join(", ")}\" sizes=\"#{sizes.join(", ")}\" src=\"#{srcset_url}\">"
    end
  end
end

Liquid::Template.register_filter(Jekyll::ZimgTagFilter)
