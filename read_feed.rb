require 'rubygems'
require 'oauth'
require 'json'
require 'certified'

baseurl = "https://api.twitter.com"
path    = "/1.1/statuses/user_timeline.json"
query   = URI.encode_www_form(
	"screen_name" => "TechCrunch",
	"count" => 1,
	)
address = URI("#{baseurl}#{path}?#{query}")
request = Net::HTTP::Get.new address.request_uri

# Print data about a Tweet
def print_timeline(tweets)
  	tweets.each do |tweet| File.open("tweet.txt", 'w') {|f| f.write(tweet["text"]) } end
end

# Set up HTTP.
http             = Net::HTTP.new address.host, address.port
http.use_ssl     = true
http.verify_mode = OpenSSL::SSL::VERIFY_PEER

# Credentials
consumer_key ||= OAuth::Consumer.new "Consumer Key", "Consumer Secret"
access_token ||= OAuth::Token.new "Access Token", "Access Token Secret"

# Issue the request.
request.oauth! http, consumer_key, access_token
http.start
response = http.request request

# Parse and print the Tweet if the response code was 200
tweets = nil
if response.code == '200' then
  tweets = JSON.parse(response.body)
  print_timeline(tweets)
end
