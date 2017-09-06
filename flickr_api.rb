require "net/http"
require "json"

class Flickr_Api
  def initialize
    @apikey = "a6d819499131071f158fd740860a5a88"
    @baseurl = "https://api.flickr.com/services/rest"
  end

  def image_search_url query
    uri = URI(@baseurl)
    params = {
      method: "flickr.photos.search",
      api_key: @apikey,
      text: query,
      safe_search: 1,
      limit: 1,
      format: "json"
    }
    uri.query = URI.encode_www_form(params)
    return uri
  end

  def get_image_url_from_photo json
    "https://farm" +
    json["farm"].to_s +
    ".staticflickr.com/" +
    json["server"].to_s + "/" +
    json["id"].to_s + "_" +
    json["secret"].to_s +
    ".jpg"
  end

  def get_first_image_for_text query
    res = Net::HTTP.get_response(image_search_url(query))
    stripped_body = res.body.match(/^jsonFlickrApi\((.*)\)$/)[1]
    json = JSON[stripped_body]
    get_image_url_from_photo json["photos"]["photo"][0]
  end
end
