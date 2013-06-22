$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "app_version"
  s.version     = "0.1.1"
  s.authors     = ["Stephen Kapp", "Phillip Toland"]
  s.email       = ["mort666@virus.org", "phil.toland@gmail.com"]
  s.homepage    = ""
  s.summary     = "APP Version Gem"
  s.description = "App Version Gem originally App Version Rails Plugin from https://github.com/toland/app_version"

  s.files = Dir["{app,config,db,lib,tasks}/**/*"] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"] 
  
  s.add_dependency "rails", "~> 3.2.8"
end
