# encoding: utf-8
require "sinatra"
require "dotenv"
require "zlib"

configure do
  # Load .env vars
  Dotenv.load
  # Disable output buffering
  $stdout.sync = true
end

get "/" do
  "It's easy, just use a url like <code>#{request.base_url}/300/200</code> to get a random Vox photo that's 300x200."
end

get %r{/(\d+)/(\d+)} do
  photos = %w{
    https://farm4.staticflickr.com/3742/11960372296_bfda2f1cdd_k.jpg
    https://farm4.staticflickr.com/3667/12451742125_4396c92b42_k.jpg
    https://farm4.staticflickr.com/3704/12451901763_9eda9c7fd5_k.jpg
    https://farm6.staticflickr.com/5528/12452261424_1d25e4cec1_k.jpg
    https://farm8.staticflickr.com/7454/13005582474_bba7d08026_k.jpg
    https://farm4.staticflickr.com/3221/13005347773_8dcec956e4_k.jpg
    https://farm3.staticflickr.com/2821/13005604234_413c7a5b8e_k.jpg
    https://farm8.staticflickr.com/7170/13587019793_886cd2aefa_k.jpg
    https://farm4.staticflickr.com/3699/13587384984_12f82abf9b_k.jpg
    https://farm4.staticflickr.com/3725/13587380844_697cc6e95b_k.jpg
    https://farm8.staticflickr.com/7182/13587010035_d65582fea9_k.jpg
    https://farm8.staticflickr.com/7250/13587061245_2101a69c42_k.jpg
    https://farm8.staticflickr.com/7111/13587097345_82637b9706_k.jpg
    https://farm3.staticflickr.com/2931/14196920247_aeef5f4c53_k.jpg
    https://farm6.staticflickr.com/5485/14196776398_4847a18607_k.jpg
    https://farm4.staticflickr.com/3876/14346942207_08aa0591b6_k.jpg
    https://farm6.staticflickr.com/5544/14347001940_52932c2f46_k.jpg
    https://farm4.staticflickr.com/3874/14347027379_8cacb561df_k.jpg
    https://farm3.staticflickr.com/2900/14517129286_0d5bddfbe9_k.jpg
    https://farm6.staticflickr.com/5527/14353665328_a04b89b771_k.jpg
    https://farm6.staticflickr.com/5513/14353580610_9ac968d027_k.jpg
    https://farm4.staticflickr.com/3841/14560338443_c6fe6a4d4d_k.jpg
    https://farm3.staticflickr.com/2902/14538715934_b37e755ee8_k.jpg
    https://farm6.staticflickr.com/5537/14538734074_315982492b_k.jpg
    https://farm9.staticflickr.com/8414/8712005517_7e5d6093d2_h.jpg
    https://farm8.staticflickr.com/7389/8718893718_d33549d5c4_k.jpg
    https://farm8.staticflickr.com/7453/8718170535_2995e398d0_k.jpg
    https://farm9.staticflickr.com/8401/8746544133_0b7ddbd648_k.jpg
    https://farm4.staticflickr.com/3684/9456136108_d0794e8cea_k.jpg
    https://farm4.staticflickr.com/3822/9456134124_e2a00b6cae_k.jpg
    https://farm8.staticflickr.com/7375/9453353633_89ff6eb819_k.jpg
  }
  cache_control :no_store, :no_cache, :must_revalidate
  redirect "#{request.env['rack.url_scheme']}://#{thumb_url(photos.sample, { :width => params[:captures][0], :height => params[:captures][1], :smart => true })}", 303
end

  # Process an image url, stolen from our middleman gem
  #
  # @param [String] Full URL to an image file
  # @param [Hash] Options for cutting the thumb:
  #  :meta => bool - flag that indicates that thumbor should return only
  #                  meta-data on the operations it would otherwise perform;
  #  :crop => [left, top, right, bottom] - Coordinates for manual cropping.
  #  :width => <int> - the width for the thumbnail;
  #  :height => <int> - the height for the thumbnail;
  #  :flip => <bool> - flag that indicates that thumbor should flip
  #                    horizontally (on the vertical axis) the image;
  #  :flop => <bool> - flag that indicates that thumbor should flip vertically
  #                    (on the horizontal axis) the image;
  #  :halign => :left, :center or :right - horizontal alignment that thumbor
  #                                        should use for cropping;
  #  :valign => :top, :middle or :bottom - horizontal alignment that thumbor
  #                                        should use for cropping;
  #  :smart => <bool> - flag indicates that thumbor should use smart cropping;
  # @return [String] Full URL to the thumbnail
  def thumb_url(image_url, options = {})
    return image_url if image_url.nil? || image_url.empty?

    require 'ruby-thumbor'
    url = image_url.strip
    url.sub!(%r{^http(s|)://}, '')

    if @thumbor_service.nil?
      if options[:unsafe]
        @thumbor_service = Thumbor::CryptoURL.new(nil)
      else
        @thumbor_service = Thumbor::CryptoURL.new(ENV['THUMBOR_SECURITY_KEY'])
      end
    end

    options[:image] = URI.escape(url)
    host = ENV['THUMBOR_SERVER_URL']
    path = @thumbor_service.generate(options)
    host = (host % (Zlib.crc32(path) % 4)) if host =~ /%d/
    host + path
  end