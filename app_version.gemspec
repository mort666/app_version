$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "app_version"
  s.version     = "0.1.16"
  s.authors     = ["Stephen Kapp", "Phillip Toland"]
  s.email       = ["mort666@virus.org", "phil.toland@gmail.com"]
  s.homepage    = "https://github.com/mort666/app_version"
  s.summary     = "Rails App Version Gem"
  s.description = "App Version Gem originally App Version Rails Plugin from https://github.com/toland/app_version, updated to run with later rails versions as a gem, currently supports Rails 4.2.x."

  s.files = Dir["{app,config,db,lib,tasks}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2"
end
