
require_relative "config"
require "sinatra"
require "sinatra/reloader" if Config[:Development?] #reloads when source files change
require_relative "twitter_api"
# require_relative "syllable_lookup"

# Syllable_table = Syllable_Table.new
twitter_api = Twitter_Api.new


get('/') {
  twitter_api.get_all_tweets_for_username("holewheatbread")
}
