# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' #unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use. To use Rails without a database
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Specify gems that this application depends on. 
  # They can then be installed with "rake gems:install" on new installations.
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "aws-s3", :lib => "aws/s3"
  config.gem "rfacebook", :version => "0.9.8"
  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Make Time.zone default to the specified zone, and make Active Record store time values
  # in the database in UTC, and return them converted to the specified local zone.
  # Run "rake -D time" for a list of tasks for finding time zone names. Comment line to use default local time.
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_youth_session',
    :secret      => 'c7dad91b97ce252551212a4eec623d3eee7e0c2939e39eca90f372f2579534f357d4725cb98686e4892f005b6f41469fd71810a1c3383d3def672033772b441b'
  }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with "rake db:sessions:create")
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
end


if RAILS_ENV != "test"
    module ActionController
      class Base
        cattr_accessor :asset_domain   # The server name portion of the asset host, w/o the protocol.
      end
    end

    module ActionView
      module Helpers
        module AssetTagHelper
          private
          def compute_public_path(source, dir, ext)
            source = source.dup
            source << ".#{ext}" if File.extname(source).blank? and !ext.blank?
            unless source =~ %r{^[-a-z]+://}
              source = "/#{dir}/#{source}" unless source[0] == ?/
              asset_id = rails_asset_id(source)
              source << '?' + asset_id if defined?(RAILS_ROOT) and !asset_id.blank?
              host = ActionController::Base.asset_domain
              if host
                host = request.protocol + host
              else
                host = ActionController::Base.asset_host
              end
              source = "#{host}#{request.relative_url_root}#{source}"
            end
            source
          end
        end
      end
    end
end

ActionController::Base.asset_domain = "sharp-fog-22.heroku.com"
ActionController::AbstractRequest.relative_url_root = "http://apps.facebook.com/youthasia"
