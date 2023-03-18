class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[show edit update destroy]

  def index
    @tweets = Tweet.all.select { |t| t.parent_id.nil? }
    @tweet = Tweet.new
  end

  def show
    @tweets = Tweet.where(parent: @tweet)
    @new_tweet = Tweet.new
  end

  def edit; end

  def create
    user = current_user
    if params[:tweet][:tweet_id]
      create_parent_tweet(user)
    else
      create_tweet(user)
    end
  end

  def update
    if @tweet.update(body: tweet_params[:body])
      redirect_to tweets_path
    else
      render "edit", status: :unprocessable_entity
    end
  end

  def destroy
    @tweet.destroy
    redirect_to "/tweet/:id"
  end

  private

  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  def tweet_params
    params.require(:tweet).permit(:body)
  end

  def create_parent_tweet(user)
    @tweet_principal = Tweet.find(params[:tweet][:tweet_id])
    @tweet = Tweet.new(body: tweet_params[:body], user:)
    @tweet_principal.replied_to << @tweet if @tweet.save
    redirect_to tweet_path(@tweet_principal)
  end

  def create_tweet(user)
    @tweet = Tweet.new(body: tweet_params[:body], user:)
    if @tweet.save
      redirect_to  tweets_path
    else
      redirect_to  tweets_path, status: :unprocessable_entity
    end
  end
end
