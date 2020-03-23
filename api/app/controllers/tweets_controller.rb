class TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = FetchTweetsService.call(country: params[:country])
  end

  private

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.permit(
        :country
      )
    end
end
