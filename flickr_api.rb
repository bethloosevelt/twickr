require "net/http"
require "json"
require "concurrent"

class Flickr_Api
  def initialize
    @apikey = "a6d819499131071f158fd740860a5a88"
    @baseurl = "https://api.flickr.com/services/rest"
  end

  private def image_search_url query
    uri = URI(@baseurl)
    params = {
      method: "flickr.photos.search",
      api_key: @apikey,
      text: query,
      safe_search: 2,
      format: "json"
    }
    uri.query = URI.encode_www_form(params)
    return uri
  end

  private def image_url_from_photo_data json
    "https://farm%{farm_id}.staticflickr.com/%{server_id}/%{post_id}_%{secret}.jpg" % {
      farm_id: json["farm"].to_s,
      server_id: json["server"].to_s,
      post_id: json["id"].to_s,
      secret: json["secret"].to_s
    }
  end

  def get_first_image_for_text query
    res = Net::HTTP.get_response(image_search_url(query))
    stripped_body = res.body.match(/^jsonFlickrApi\((.*)\)$/)[1]
    json_res = JSON[stripped_body]
    image_url_from_photo_data json_res["photos"]["photo"][0]
  end

  def get_first_image_for_text_array queries
    urls = Array.new
    task_list = Array.new
    queries.each{ |query|
      task_list.push Concurrent::Future.execute {
        get_first_image_for_text query[0]
      }
    }
    while task_list.reduce(false) {
        |lhs, rhs|
        lhs || !rhs.complete?
      }
    end
    urls = task_list.map{|task|
      task = task.value
    }
    return urls
  end

end
