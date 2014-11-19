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
    https://farm6.staticflickr.com/5153/14668149303_3c75aedfd5_k.jpg
    https://farm3.staticflickr.com/2917/14647848682_0355c05117_k.jpg
    https://farm3.staticflickr.com/2917/14648256175_ff40043ee9_k.jpg
    https://farm4.staticflickr.com/3886/14461847537_117d321d5d_k.jpg
    https://farm4.staticflickr.com/3925/14645016611_3f0278d8d8_k.jpg
    https://farm4.staticflickr.com/3875/14461652899_d272c88177_k.jpg
    https://farm6.staticflickr.com/5233/14461650129_156943ee43_k.jpg
    https://farm4.staticflickr.com/3876/14668183563_07afdb3b12_k.jpg
    https://farm4.staticflickr.com/3922/14625293886_236e191621_k.jpg
    https://farm6.staticflickr.com/5472/14461669288_46b3944170_k.jpg
    https://farm3.staticflickr.com/2934/14461662388_1e640d5fcc_k.jpg
    https://farm4.staticflickr.com/3907/14461655459_dc8213587d_k.jpg
    https://farm6.staticflickr.com/5567/14647882342_36d9ed8109_k.jpg
    https://farm3.staticflickr.com/2897/14461599840_86a7703381_k.jpg
    https://farm3.staticflickr.com/2905/14647888662_a20b0e8931_k.jpg
    https://farm6.staticflickr.com/5529/14646106034_0a19ea77d9_k.jpg
    https://farm6.staticflickr.com/5472/14646103814_fb203bdf73_k.jpg
    https://farm3.staticflickr.com/2934/14461882797_858e36592d_k.jpg
    https://farm3.staticflickr.com/2916/14648315275_b6de1ef5ae_k.jpg
    https://farm4.staticflickr.com/3863/14648301385_ea7c2807be_k.jpg
    https://farm3.staticflickr.com/2900/14646110464_8f567ea6fc_k.jpg
    https://farm4.staticflickr.com/3822/13587086935_0789635ffc_k.jpg
    https://farm4.staticflickr.com/3770/13587445414_965562da19_k.jpg
    https://farm4.staticflickr.com/3809/13210364405_7b3ff05b45_k.jpg
    https://farm4.staticflickr.com/3808/13208308963_118ff2329f_k.jpg
    https://farm3.staticflickr.com/2816/12451717145_5a407d3aa0_k.jpg
    https://farm3.staticflickr.com/2892/12451706855_8c1e03d352_k.jpg
    https://farm8.staticflickr.com/7317/12452227274_a19e591de1_k.jpg
    https://farm8.staticflickr.com/7407/12451694725_7a40823ec6_k.jpg
    https://farm6.staticflickr.com/5520/12452181134_1b1e165153_k.jpg
    https://farm4.staticflickr.com/3807/12046911863_24ce596d38_k.jpg
    https://farm6.staticflickr.com/5502/11620831034_c4f4cadaa5_k.jpg
    https://farm4.staticflickr.com/3825/10758220115_20cd212b0c_k.jpg
    https://farm8.staticflickr.com/7453/10758298496_71cda2a77a_k.jpg
    https://farm4.staticflickr.com/3727/10681279516_a789e013cc_k.jpg
    https://farm4.staticflickr.com/3826/10463777713_4ebd9e6a15_o.jpg
    https://farm8.staticflickr.com/7315/10463598986_f4ac890ab8_o.jpg
    https://farm6.staticflickr.com/5542/10179184046_bf75ea5ad0_k.jpg
    https://farm9.staticflickr.com/8138/10168317595_c418d7784f_k.jpg
    https://farm9.staticflickr.com/8355/8413205109_0c5cc5376b_k.jpg
    https://farm9.staticflickr.com/8459/8028753675_73ce08c96c_k.jpg
    https://farm8.staticflickr.com/7249/7650227434_39b186c1e7_k.jpg
    https://farm9.staticflickr.com/8026/7650221778_a18e0ce50e_k.jpg
    https://farm9.staticflickr.com/8248/8506137590_ee3c8a735c_k.jpg
    https://farm9.staticflickr.com/8248/8506136636_8cb8ec4459_k.jpg
    https://farm9.staticflickr.com/8247/8497501829_7d13249800_k.jpg
    https://farm9.staticflickr.com/8377/8497502519_c407219f4e_k.jpg
    https://farm9.staticflickr.com/8526/8505042149_f3365c1397_k.jpg
    https://farm9.staticflickr.com/8507/8497503601_c3015f38ae_k.jpg
    https://farm9.staticflickr.com/8230/8505009859_53de634625_k.jpg
    https://farm9.staticflickr.com/8097/8569514204_4970140cec_o.jpg
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