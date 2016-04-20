source "https://rubygems.org"

gem "activesupport"
gem "chef", "~> 10.34"
gem "foodcritic", "!= 1.4.0", "< 5.0.0" # 5+ requires Ruby 2.0.0, https://github.com/acrmp/foodcritic/issues/37
gem "knife-ec2"
gem "minitest-chef-handler"
gem "rake"
gem "rspec", "~> 2.0"
gem "spiceweasel"
gem "webmock", "< 1.24.3" # https://github.com/bblimke/webmock/issues/607 https://github.com/rubygems/rubygems/commit/da4362a6644ca5a75c210677ac500bccfe75f529

group :development do
  gem "growl"
  gem "guard"
  gem "guard-bundler"
  gem "guard-foodcritic"
  gem "guard-rspec"
  gem "rb-fsevent"
end
