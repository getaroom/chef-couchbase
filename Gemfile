source "https://rubygems.org"

gem "activesupport", "< 5" # 5.0.0 requires Ruby >= 2.2.2
gem "chef", "~> 10.34"
gem "foodcritic", "!= 1.4.0", "< 5.0.0" # 5+ requires Ruby 2.0.0, https://github.com/acrmp/foodcritic/issues/37
gem "knife-ec2", "< 0.14" # 0.14.0 requires Ruby >= 2.2.2
gem "minitest-chef-handler"
gem "net-http-persistent", "< 3.0" # indirect dependency, 3.0.0 requires Ruby ~> 2.1
gem "public_suffix", "< 1.5" # indirect dependency, 1.5 depends on Ruby >= 2.0
gem "rake"
gem "rspec", "~> 2.0"
gem "solve", "< 3" # indirect dependency, 3.0.0 requires Ruby >= 2.1.0
gem "spiceweasel"
gem "webmock", ">= 1.24.6", "< 2.0"

group :development do
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-foodcritic"
  gem "guard-rspec"
  gem "listen", "~> 3.0.6" # indirect dependency, 3.1 depends on Ruby ~> 2.2
end
