require 'app_version/app_version'
require 'rails'

#
# Add App::Version Rake tasks
#
module AppVersion
  #
  # Add App::Version Rake tasks
  # 
  class Railtie < Rails::Railtie
    railtie_name :app_version

    rake_tasks do
      load "tasks/app_version_tasks.rake"
    end
  end
end
