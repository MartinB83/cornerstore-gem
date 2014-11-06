require 'active_model'
require 'rest_client'

require 'cornerstore/version'
require 'cornerstore/resource'
require 'cornerstore/model'
require 'cornerstore/api'

module RestClient::AbstractResponse
  def success?
    (200..207).include? code
  end
end

RestClient.log = Object.new.tap do |proxy|
  def proxy.<<(message)
    Rails.logger.info message
  end
end

module Cornerstore
  class << self
    attr_writer :subdomain, :api_key
  end

  def self.subdomain
    @subdomain ||= read_config[:subdomain]
  end

  def self.root_url
    "https://#{subdomain}.cornerstore.io/api/v1"
  end

  def self.assets_url
    "http://cskit-production.s3.amazonaws.com"
  end

  def self.headers
    {
      user_agent: "cornerstore-gem/#{Cornerstore::VERSION}",
      authorization: "Token #{api_key}"
    }
  end

private
  # We have three levels of configuration
  # - Can be manually set with accessors on this module
  # - Can be supplied by Rails secret file
  # - Can be supplied by a cornerstore yml file
  # - Can be supplied via CORNERSTORE_URL env variable
  def self.read_config
    config = {}

    # ENV variable set beats everything. If we got one we use it regardless
    # of other config options
    if ENV.has_key?('CORNERSTORE_URL') and uri = URI.parse(ENV['CORNERSTORE_URL'])
      config[:subdomain] = uri.host.sub('.cornerstore.io', '')
      config[:api_key]   = uri.password

    else
      # Is this Rails?
      if defined?(Rails)
        # Try to get the credentials from the secret storage,
        # if that fails try to read the YAML file
        if not (Rails.application.respond_to?(:secrets) and
          config[:subdomain] = Rails.application.secrets.cornerstore_subdomain and
          config[:api_key] = Rails.application.secrets.cornerstore_api_key)

          yml_path = Rails.root.join('config', 'cornerstore.yml')

          if File.exists?(yml_path) and yaml = YAML.load(File.read(yml_path))
            config[:subdomain] = yaml[Rails.env]['subdomain']
            config[:api_key]   = yaml[Rails.env]['api_key']
          end
        end

      else
        raise ArgumentError, 'Could not find any Cornerstore credentials, please set them before proceeding'
      end
    end

    return config
  end

  def self.api_key
    @api_ley ||= read_config[:api_key]
  end
end
