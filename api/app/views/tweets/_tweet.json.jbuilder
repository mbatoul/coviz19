json.extract! tweet, :id, :index, :created_at, :updated_at
json.url tweet_url(tweet, format: :json)
