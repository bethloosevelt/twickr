require "sinatra"
require "sinatra/reloader"
require_relative "twitter_api"
require_relative "common_word_identifier"
require_relative "flickr_api"

$twitter_api = Twitter_Api.new
$common_word_identifier = Common_Word_Identifier.new
$flickr_api = Flickr_Api.new

def top_ten_words tweets
  uncommon_words =
    tweets.flat_map{ |tweet| tweet = tweet.split(" ") }
    .map { |text|
      text = text.sub(/[^a-zA-Z]/, "").downcase
    }
    .select{ |word| word[/.+/] }
    .select{ |word| (!$common_word_identifier.is_common? word) }

  freq = Hash.new(0)
  uncommon_words.each { |word|
    freq[word] += 1
  }
  freq.sort { |l, r| r[1]<=>l[1] }.take(10)
end

get("/:username") {
  all_tweets = $twitter_api.get_all_tweets_for_username(params[:username])
  if all_tweets == nil
    return 404, "error retreiving tweets"
  end
  top_words = top_ten_words(all_tweets)
  urls = $flickr_api.get_first_image_for_text_array top_words
  ERB.new(File.read("./index.erb")).result(binding)
}
