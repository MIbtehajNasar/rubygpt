# frozen_string_literal: true

require_relative "rubygpt/version"
require "httparty"
require "rubygpt/client"

module RubyGpt
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :access_token

    def initialize
        @access_token = ""
    end

    def access_token
      return @access_token if @access_token

      error_text = "OpenAI access token missing!"
      raise ConfigurationError, error_text
    end
  end
end
