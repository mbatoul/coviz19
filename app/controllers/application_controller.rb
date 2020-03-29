# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Caching
  include ActionController::MimeResponds
end
