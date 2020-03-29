# frozen_string_literal: true

class V1::TweetsController < ApplicationController
  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = FetchTweetsService.call(zones: params[:zones])
  end

  private

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.permit(
        :zones
      )
    end
end
