require "rails_helper"
require "faker"

describe "Tweets", type: :request do
  describe "index path" do
    it "respond with http success status code" do
      user = User.create(username: Faker::Internet.username, name: Faker::Artist.name,
                         email: Faker::Internet.email, password: "123456")
      post "/api/login", params: { email: user.email, password: user.password }
      token = JSON.parse(response.body)["token"]
      get "/api/tweets", headers: { "Authorization" => "Token token=#{token}" }
      expect(response.status).to eq(200)
    end
    it "returns a json with all tweets" do
      user = User.create(username: Faker::Internet.username, name: Faker::Artist.name,
                         email: Faker::Internet.email, password: "123456")
      post "/api/login", params: { email: user.email, password: user.password }
      token = JSON.parse(response.body)["token"]
      Tweet.create(body: "Test", user:)
      get "/api/tweets", headers: { "Authorization" => "Token token=#{token}" }
      tweets = JSON.parse(response.body)
      expect(tweets.size).to eq 1
    end
  end
  describe "show path" do
    it "respond with tweet id and body" do
      user = User.create(username: Faker::Internet.username, name: Faker::Artist.name,
                         email: Faker::Internet.email, password: "123456")
      post "/api/login", params: { email: user.email, password: user.password }
      token = JSON.parse(response.body)["token"]
      tweet = Tweet.create(body: "Testing", user:)
      get "/api/tweets/#{tweet.id}", headers: { "Authorization" => "Token token=#{token}" }
      tweet_json = JSON.parse(response.body)
      unless tweet_json["unauthorized"]
        expect(tweet.id).to eq(tweet_json["id"])
        expect(tweet.body).to eq(tweet_json["body"])
      end
    end
  end
  describe "create path" do
    it "respond with create successful" do
      user = User.create(username: Faker::Internet.username, name: Faker::Artist.name,
                         email: Faker::Internet.email, password: "123456")
      post "/api/login", params: { email: user.email, password: user.password }
      token = JSON.parse(response.body)["token"]

      post "/api/tweets", headers: { "Authorization" => "Token token=#{token}" }, params: { body: "Test", email: user.email }
      expect(response).to have_http_status(:created)
    end
  end
  describe "update path" do
    it "respond with ok update correct" do
      user = User.create(username: Faker::Internet.username, name: Faker::Artist.name,
                         email: Faker::Internet.email, password: "123456")
      post "/api/login", params: { email: user.email, password: user.password }
      token = JSON.parse(response.body)["token"]
      tweet = Tweet.create(body: "Testing", user:)
      patch "/api/tweets/#{tweet.id}", params: { id: tweet.id, body: "Update testing" }, headers: { "Authorization" => "Token token=#{token}" }
      expect(response).to have_http_status(:ok)
    end
  end
  describe "destroy path" do
    it "respond with ok destroy correct" do
      user = User.create(username: Faker::Internet.username, name: Faker::Artist.name,
                         email: Faker::Internet.email, password: "123456")
      post "/api/login", params: { email: user.email, password: user.password }
      token = JSON.parse(response.body)["token"]
      tweet = Tweet.create(body: "Testing", user:)
      delete "/api/tweets/#{tweet.id}", headers: { "Authorization" => "Token token=#{token}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
