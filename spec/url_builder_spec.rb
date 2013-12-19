require 'spec_helper'

describe Imageproxy::UrlBuilder do
  before :each do
    ENV["IMAGEPROXY_URL"] = "http://imageproxy.com"
    ENV["IMAGEPROXY_SIGNATURE_SECRET"] = "SECRET"
  end

  it "generates a url" do
    Imageproxy::UrlBuilder.build_resize_url("http://example.com/image.png", "200x200").should ==
      "http://imageproxy.com/convert?resize=200x200&shape=cut&source=http%3A%2F%2Fexample.com%2Fimage.png&signature=49FuVHqCD-LmDvIoR1jn7LTKeD4%3D"
  end
end
