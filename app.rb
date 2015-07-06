# encoding: utf-8
require "sinatra"
require "dotenv"
require "zlib"
require "httparty"
require "redis"

configure do
  # Load .env vars
  Dotenv.load
  # Set up redis
  uri = URI.parse(ENV["REDIS_URL"])
  $redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
  # Disable output buffering
  $stdout.sync = true
end

get "/" do
  erb :index
end

get %r{/(\d+)/(\d+)} do
  photo = get_photo_url
  cache_control :no_store, :no_cache, :must_revalidate
  redirect "#{request.env['rack.url_scheme']}://#{thumb_url(photo, { :width => params[:captures][0], :height => params[:captures][1], :smart => true })}", 303
end

def get_photo_url
  photos = $redis.get("flickr:photos")
  if photos.nil?
    photos = get_photos.to_json
    $redis.setex("flickr:photos", 60*60*24, photos)
  end
  photos = JSON.parse(photos)
  photos.sample
end

def get_photos(page = 1)
  url = "https://api.flickr.com/services/rest/?method=flickr.groups.pools.getPhotos&api_key=#{ENV['FLICKR_API_KEY']}&group_id=#{ENV['FLICKR_GROUP_ID']}&extras=url_k&per_page=500&page=#{page}&format=json&nojsoncallback=1"
  response = JSON.parse(HTTParty.get(url).body)
  photos = response["photos"]["photo"].reject{ |p| p["url_k"].nil? }.map{ |p| p["url_k"] }
  unless response["photos"]["page"] == response["photos"]["pages"]
    photos << get_photos(page + 1)
  end
  photos.flatten
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