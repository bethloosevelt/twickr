
require_relative "config"
require "sinatra"
require "sinatra/reloader" if Config[:Development?] #reloads when source files change
require_relative "twitter_api"
require_relative "common_word_identifier"
require_relative "flickr_api"

twitter_api = Twitter_Api.new
Common_word_identifier = Common_Word_Identifier.new
Flickr_api = Flickr_Api.new

def top_ten_words tweets
  concatonated = tweets.join(" ")
  freq = Hash.new
  concatonated.split(" ").each { |word|
    word = word.downcase
    unless freq.has_key? word
      freq[word] = 1
    else
      freq[word] += 1
    end
  }
  freq.select{ |word| (!Common_word_identifier.is_common? word) && (word[0] != "@") }
    .sort { |l, r| r[1]<=>l[1] }
    .take(10)
end

index_template =
  "<% top.each do |word| %>
    <p>
      <%= word %>
      <img src=\" <%= urls[word[0]] %> \"/>
    </p>
   <% end %>"

get("/:username") {
  all_tweets = twitter_api.get_all_tweets_for_username(params[:username])
  top = top_ten_words(all_tweets)
  urls = Hash.new
  top.map{ |word| urls[word[0]] = Flickr_api.get_first_image_for_text word[0] }
  ERB.new(index_template).result(binding)
}
