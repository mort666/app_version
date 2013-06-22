require 'app_version/app_version'
require 'rails'   

module AppVersion
  class Railtie < Rails::Railtie
    railtie_name :app_version

    rake_tasks do
      load "tasks/app_version_tasks.rake"
    end
  end
end