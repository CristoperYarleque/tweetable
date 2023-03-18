module Api
  class TweetsController < ApiController
    def index
      tweets = Tweet.all.select { |t| t.parent_id.nil? }
      render json: tweets, status: :ok
    end

    def show
      tweet = Tweet.find(params[:id])
      tweets = Tweet.where(parent: tweet)
      if tweets.empty?
        respond_unauthorized("no tweet parent found")
      else
        render json: tweets, status: :ok
      end
    end

    def create
      user = User.find_by(email: params[:email])
      tweet = Tweet.create(body: params[:body], user:)
      if user
        render json: tweet, status: :created
      else
        respond_unauthorized("user does not exist")
      end
    end

    def update
      tweet = Tweet.find(params[:id])
      if tweet.update(body: params[:body])
        render json: tweet, status: :ok
      else
        respond_unauthorized("could not update")
      end
    end

    def destroy
      tweet = Tweet.find(params[:id])
      if tweet.destroy
        render json: tweet, status: :ok
      else
        respond_unauthorized("could not be eliminated")
      end
    end
  end
end
