$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "app_version/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "app_version"
  s.version     = AppVersion::VERSION
  s.authors     = ["Scott Curry", "Stephen Kapp", "Phillip Toland"]
  s.email       = ["coder.scottcurry.com", "mort666@virus.org", "phil.toland@gmail.com"]
  s.homepage    = "https://github.com/mort666/app_version"
  s.summary     = "Rails App Version Gem"
  s.description = "App Version Gem originally App Version Rails Plugin from https://github.com/toland/app_version, updated to run in CI server and with later rails versions as a gem, currently supports Rails 5.2+"

  s.files = Dir["{app,config,db,lib,tasks}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 5.2.4.5"
end
