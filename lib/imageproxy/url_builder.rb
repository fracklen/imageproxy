require 'active_support/core_ext'

module Imageproxy
  class UrlBuilder
    class << self
      def build_resize_url(image_url, size)
        unsigned_url = [resize_path, params(image_url,size)].join("?")
        signed_url = sign(unsigned_url)
        [base_url, signed_url].join
      end

      private

      def resize_path
        "/convert"
      end

      def params(path, size)
        {
          :resize => size,
          :source => path,
          :shape => :cut
        }.to_query
      end

      def base_url
        ENV["IMAGEPROXY_URL"]
      end

      def signature(path)
        Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret, path)).strip.tr('+/', '-_')
      end

      def secret
        ENV["IMAGEPROXY_SIGNATURE_SECRET"]
      end

      def sign(url)
        if secret
          "#{url}&#{{:signature => signature(url)}.to_query}"
        else
          url
        end
      end
    end
  end
end
