# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

#uncomment to use secrets.yml
#APP_CONFIG = YAML.load_file("#{Rails.root}/config/secrets.yml")

APP_CONFIG = YAML.load_file("#{RAILS_ROOT}/config/config.yml")