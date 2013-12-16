module Imageproxy
  class Service
    def self.resized_url(path, size)
      "#{host}#{sign(resize_path + params(path,size))}"
    end

    private

    def self.resize_path
      "/convert?shape=cut&"
    end

    def self.params(path, size)
      {
        :resize => size,
        :source => path,
      }.to_query
    end

    def self.host
      ENV["IMAGEPROXY_HOST"]
    end

    def self.signature(path)
      Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret, path)).strip.tr('+/', '-_')
    end

    def self.secret
      ENV["IMAGEPROXY_SECRET"]
    end

    def self.sign(url)
      if secret
        "#{url}&#{{:signature => signature(url)}.to_query}"
      else
        url
      end
    end
  end
end
