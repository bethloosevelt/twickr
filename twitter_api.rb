require "twitter"
require_relative "config"

class Twitter_Api
  def initialize
    @client = Twitter::REST::Client.new do |config|
      config.consumer_key = "YxLmOapaT2ZW3lCfkIxysmXRo"
      config.consumer_secret = "Iq9LlZgfVeBDoeHHCEGwNCLCcFDVB0GR5EFmzBfJLSzjC6UonD"
      config.access_token = "382427413-C5tRQJGAShHbB3k1lk5t5C5ySbKXMBWYojcWppw4"
      config.access_token_secret = "aGkPBv4gqczpzeaZaYtKHFYNn8iWE8QWYxV18IvmA3h2h"
    end
  end
  def get_latest_tweet
    return @client.search("hello", lang: "en").first.text
  end
  def get_all_tweets_for_username username
    @client.user_timeline(username, :count => 3200).map { |tweet|
      tweet = tweet.text
    }
  end
end
