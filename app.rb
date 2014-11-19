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
  erb :index
end

get %r{/(\d+)/(\d+)} do
  photos = %w{
    https://farm6.staticflickr.com/5511/14666635973_53464d4743_o.jpg
    https://farm3.staticflickr.com/2917/14648256175_d39b452ef3_o.jpg
    https://farm3.staticflickr.com/2917/14647848682_01fe3f4660_o.jpg
    https://farm4.staticflickr.com/3925/14645016611_7a6957d1dd_o.jpg
    https://farm4.staticflickr.com/3886/14461847537_24f5a9d9c0_o.jpg
    https://farm3.staticflickr.com/2898/14461845807_d683137497_o.jpg
    https://farm4.staticflickr.com/3875/14461652899_e2e62dfb0c_o.jpg
    https://farm4.staticflickr.com/3876/14668183563_d53e6935d8_o.jpg
    https://farm4.staticflickr.com/3922/14625293886_69527898ff_o.jpg
    https://farm6.staticflickr.com/5472/14461669288_8ef45d0dbd_o.jpg
    https://farm3.staticflickr.com/2934/14461662388_93bb94868d_o.jpg
    https://farm4.staticflickr.com/3907/14461655459_d679eea2e3_o.jpg
    https://farm3.staticflickr.com/2897/14461599840_74ff409a2a_o.jpg
    https://farm3.staticflickr.com/2905/14647888662_e8007ac7cf_o.jpg
    https://farm6.staticflickr.com/5529/14646106034_b307ec555a_o.jpg
    https://farm6.staticflickr.com/5472/14646103814_0f3ab32e3c_o.jpg
    https://farm3.staticflickr.com/2934/14461882797_abb90d7f76_o.jpg
    https://farm4.staticflickr.com/3863/14648301385_39d8155836_o.jpg
    https://farm3.staticflickr.com/2900/14646110464_802be0a41d_o.jpg
    https://farm4.staticflickr.com/3844/14461637210_99469fc850_o.jpg
    https://farm3.staticflickr.com/2902/14538715934_aa950b14be_o.jpg
    https://farm6.staticflickr.com/5513/14353580610_cefbc4b2f1_o.jpg
    https://farm6.staticflickr.com/5537/14538734074_c1cec31bb7_o.jpg
    https://farm4.staticflickr.com/3868/14536852031_dca23b9944_o.jpg
    https://farm3.staticflickr.com/2900/14517129286_3d9faafe3f_o.jpg
    https://farm6.staticflickr.com/5527/14353665328_b7881151ce_o.jpg
    https://farm4.staticflickr.com/3873/14532167814_7d8c61accb_o.jpg
    https://farm6.staticflickr.com/5544/14347001940_fd04af7a01_o.jpg
    https://farm4.staticflickr.com/3874/14347027379_f0fae2969a_o.jpg
    https://farm4.staticflickr.com/3876/14346942207_e8aa40689c_o.jpg
    https://farm6.staticflickr.com/5485/14196776398_25243b0199_o.jpg
    https://farm3.staticflickr.com/2931/14196920247_c859a6e23b_o.jpg
    https://farm6.staticflickr.com/5223/14020674724_189142dd73_o.jpg
    https://farm8.staticflickr.com/7126/14040193953_3e63b28990_o.jpg
    https://farm8.staticflickr.com/7376/13587509064_d95520bd8a_o.jpg
    https://farm3.staticflickr.com/2826/13587149933_7cee270eea_o.jpg
    https://farm4.staticflickr.com/3817/13587100935_5a38ea4844_o.jpg
    https://farm4.staticflickr.com/3774/13587133593_9ea9c33cf5_o.jpg
    https://farm8.staticflickr.com/7111/13587097345_d8ac37e024_o.jpg
    https://farm8.staticflickr.com/7066/13587463704_f6f67cd812_o.jpg
    https://farm4.staticflickr.com/3807/13587450884_83e4040547_o.jpg
    https://farm4.staticflickr.com/3770/13587445414_ec296158f2_o.jpg
    https://farm8.staticflickr.com/7380/13587067985_8a9910d522_o.jpg
    https://farm8.staticflickr.com/7250/13587061245_706e1c854b_o.jpg
    https://farm8.staticflickr.com/7256/13587061783_1b2eb24995_o.jpg
    https://farm8.staticflickr.com/7182/13587010035_10d34c6f27_o.jpg
    https://farm4.staticflickr.com/3699/13587384984_3957f737c5_o.jpg
    https://farm4.staticflickr.com/3725/13587380844_729885d119_o.jpg
    https://farm3.staticflickr.com/2870/13587372144_44ee5fe855_o.jpg
    https://farm8.staticflickr.com/7170/13587019793_c5c2cb27ab_o.jpg
    https://farm4.staticflickr.com/3809/13210364405_0439118958_o.jpg
    https://farm4.staticflickr.com/3808/13208308963_65cba3350b_o.jpg
    https://farm3.staticflickr.com/2821/13005604234_8787309c17_o.jpg
    https://farm4.staticflickr.com/3221/13005347773_0c020082b3_o.jpg
    https://farm8.staticflickr.com/7454/13005582474_ccffa6fa2c_o.jpg
    https://farm4.staticflickr.com/3726/12451774865_44aa7e2945_o.jpg
    https://farm6.staticflickr.com/5528/12452261424_6c857e183f_o.jpg
    https://farm4.staticflickr.com/3704/12451901763_131aef89df_o.jpg
    https://farm4.staticflickr.com/3667/12451742125_5d051c74d5_o.jpg
    https://farm8.staticflickr.com/7317/12452227274_0c14f977d4_o.jpg
    https://farm3.staticflickr.com/2816/12451717145_bef87e97dd_o.jpg
    https://farm3.staticflickr.com/2892/12451706855_04ce8516ef_o.jpg
    https://farm8.staticflickr.com/7407/12451694725_7282bf5062_o.jpg
    https://farm6.staticflickr.com/5520/12452181134_8985929282_o.jpg
    https://farm8.staticflickr.com/7339/12089831074_c7af359e55_o.jpg
    https://farm4.staticflickr.com/3804/12090117526_ae08e010a0_o.jpg
    https://farm8.staticflickr.com/7406/12046968483_e97e179f48_o.jpg
    https://farm4.staticflickr.com/3695/12047526166_3a6c830cff_o.jpg
    https://farm6.staticflickr.com/5479/12046652865_605bf9e94e_o.jpg
    https://farm8.staticflickr.com/7371/12047038554_b01572a888_o.jpg
    https://farm3.staticflickr.com/2812/12046635425_2c0a053e9e_o.jpg
    https://farm4.staticflickr.com/3807/12046911863_ea06fa21e5_o.jpg
    https://farm4.staticflickr.com/3742/11960372296_f5accc5cab_o.jpg
    https://farm4.staticflickr.com/3751/11806764455_7561f74a5a_o.jpg
    https://farm6.staticflickr.com/5512/11807157934_faa083c045_o.jpg
    https://farm6.staticflickr.com/5502/11620831034_d2b03fdb02_o.jpg
    https://farm3.staticflickr.com/2891/11621215786_e928b0de77_o.jpg
    https://farm4.staticflickr.com/3825/10758220115_4c7d99f7f3_o.jpg
    https://farm8.staticflickr.com/7453/10758298496_3892f4660b_o.jpg
    https://farm6.staticflickr.com/5481/10681496264_6a33e4bfc0_o.jpg
    https://farm8.staticflickr.com/7431/10681499064_9bd32d7776_o.jpg
    https://farm4.staticflickr.com/3695/10681255074_a0dc9c8930_o.jpg
    https://farm6.staticflickr.com/5525/10681452663_64360babe8_o.jpg
    https://farm4.staticflickr.com/3777/10681291174_6307423ef6_o.jpg
    https://farm4.staticflickr.com/3727/10681279516_bdcaca8583_o.jpg
    https://farm4.staticflickr.com/3832/10681287996_0559ff6b69_o.jpg
    https://farm6.staticflickr.com/5493/10681283806_71a4fa9701_o.jpg
    https://farm4.staticflickr.com/3795/10681320844_80f6dcd3a8_o.jpg
    https://farm4.staticflickr.com/3667/10681307496_65637e34bf_o.jpg
    https://farm6.staticflickr.com/5513/10681273905_6ecf1d8624_o.jpg
    https://farm3.staticflickr.com/2886/10681526043_f700e3e597_o.jpg
    https://farm3.staticflickr.com/2809/10681288975_082e57497e_o.jpg
    https://farm4.staticflickr.com/3688/10681351656_b72a6bfbcc_o.jpg
    https://farm4.staticflickr.com/3826/10463777713_4ebd9e6a15_o.jpg
    https://farm8.staticflickr.com/7315/10463598986_f4ac890ab8_o.jpg
    https://farm4.staticflickr.com/3749/10179222313_cec71d98d7_o.jpg
    https://farm4.staticflickr.com/3682/10179210423_788c1bbc5a_o.jpg
    https://farm3.staticflickr.com/2882/10179172226_7a87a860a7_o.jpg
    https://farm4.staticflickr.com/3833/10179170096_6d230d674e_o.jpg
    https://farm6.staticflickr.com/5461/10179018194_a152135f4c_o.jpg
    https://farm6.staticflickr.com/5542/10179184046_ba5c26274d_b.jpg
    https://farm3.staticflickr.com/2865/10179024664_792fdbfce4_o.jpg
    https://farm6.staticflickr.com/5496/10179248333_bdf315eca3_o.jpg
    https://farm3.staticflickr.com/2838/10179258373_80434d9280_o.jpg
    https://farm8.staticflickr.com/7458/10179153045_8847c94a40_o.jpg
    https://farm4.staticflickr.com/3822/9456134124_d6d778c1f5_o.jpg
    https://farm8.staticflickr.com/7453/8718170535_8e7d9a40f5_o.jpg
    https://farm8.staticflickr.com/7389/8718893718_99e6484892_o.jpg
    https://farm9.staticflickr.com/8414/8712005517_7150d31ab2_o.jpg
    https://farm9.staticflickr.com/8097/8569514204_4970140cec_o.jpg
    https://farm9.staticflickr.com/8529/8569514248_83c03e7eea_o.jpg
    https://farm9.staticflickr.com/8238/8506031490_46ce862732_o.jpg
    https://farm9.staticflickr.com/8101/8506033762_18be96767c_o.jpg
    https://farm9.staticflickr.com/8505/8506067962_da63687c1a_o.jpg
    https://farm9.staticflickr.com/8517/8504957931_afe6c7008c_o.jpg
    https://farm9.staticflickr.com/8092/8504977693_1a3caae311_o.jpg
    https://farm9.staticflickr.com/8090/8506099678_f287acaa7c_o.jpg
    https://farm9.staticflickr.com/8105/8506107134_229bbce33c_o.jpg
    https://farm9.staticflickr.com/8230/8505009859_cdf5e21549_o.jpg
    https://farm9.staticflickr.com/8383/8506132388_0df3dc87e1_o.jpg
    https://farm9.staticflickr.com/8375/8505023957_07589fd0fa_o.jpg
    https://farm9.staticflickr.com/8248/8506137590_36da7163f9_o.jpg
    https://farm9.staticflickr.com/8248/8506136636_59a67077e8_o.jpg
    https://farm9.staticflickr.com/8526/8505042149_9c855ec7f7_o.jpg
    https://farm9.staticflickr.com/8475/8414310264_afb3b57bc1_o.jpg
    https://farm9.staticflickr.com/8355/8413205109_f386ba3cf4_o.jpg
    https://farm9.staticflickr.com/8454/7949806230_d550088f89_o.jpg
    https://farm8.staticflickr.com/7244/7173827802_5a43a3c7dc_o.jpg
    https://farm6.staticflickr.com/5324/7173811502_b38d3d802c_o.jpg
    https://farm8.staticflickr.com/7232/7173805950_a64c99b2b0_o.jpg
    https://farm9.staticflickr.com/8162/6961274190_a7db55741c_o.jpg
    https://farm4.staticflickr.com/3672/9674605489_7296c7f3d5_o.jpg
    https://farm3.staticflickr.com/2829/9677821690_038f010d51_o.jpg
    https://farm3.staticflickr.com/2818/9674595211_2f28d3da2a_o.jpg
    https://farm8.staticflickr.com/7375/9453353633_4dfbce181c_o.jpg
    https://farm3.staticflickr.com/2809/9674606975_0585efb8b6_o.jpg
    https://farm8.staticflickr.com/7124/6961236686_93b234bf5a_o.jpg
    https://farm8.staticflickr.com/7043/7107313565_d4a12af276_o.jpg
    https://farm8.staticflickr.com/7041/7107332399_a731ddb2b1_o.jpg
    https://farm9.staticflickr.com/8019/6961299246_7ca0f4c6cb_o.jpg
    https://farm8.staticflickr.com/7121/7107364477_d1da30f2f6_o.jpg
    https://farm3.staticflickr.com/2247/4508121316_2cef211ab0_o.jpg
    https://farm7.staticflickr.com/6204/6129067838_68f3eed410_o.jpg
    https://farm4.staticflickr.com/3948/15470466187_0d4f8f1440_o.jpg
    https://farm8.staticflickr.com/7463/15656424665_53b9667309_o.jpg
    https://farm4.staticflickr.com/3946/15036269103_acf3a40eba_o.jpg
    https://farm4.staticflickr.com/3936/15470276448_e156d0b11c_o.jpg
    https://farm6.staticflickr.com/5615/15036263313_9fe0d4fd09_o.jpg
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