source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.1'

gem 'rails', '~> 5.2.4.3'
gem 'pg'
gem 'puma'
gem 'sass-rails', '>= 6'
gem 'uglifier', '>= 1.3.0' #webpack in rails 6 for JS
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

group :development do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd' #uml; sudo apt-get install graphviz; bundle exec erd
  gem 'faker' #FILL THE DATABASE WITH FAKE DATA
end

#basic
gem 'haml'
gem 'bootstrap' # bootstrap4 WEBPACKER
gem 'jquery-rails', '~> 4.3.5' # for bootstrap WEBPACKER
gem 'simple_form'
gem 'font-awesome-sass' #FONT_AWESOME ICONS
#auth
gem 'devise'
gem 'milia', '~>1.3', :git => 'https://github.com/jekuno/milia.git' #MULTITENANCY
gem 'activerecord-session_store' #MULTITENANCY FOR STORING TENANT IN SESSION
gem "rolify" #USER ROLES
gem "pundit" #AUTHORIZATION
gem 'devise_invitable', '~> 2.0.0'
#charts
gem "chartkick" #EASY CHARTS FOR RAILS
gem 'groupdate' #GROUPING BY PERIOD MADE EASY. NEEDED FOR CHARTKICK
#data
gem 'pagy' #PAGINATION
gem 'ransack' #SEARCH
gem 'money-rails' #HANDLING MONEY IN THE DATABASE
gem 'public_activity', github: 'chaps-io/public_activity' #TABLE WITH CRUD HISTORY
gem 'friendly_id'
gem 'wicked' #turn conrollers (forms) into step-by-step wizards
#PDF
gem 'wicked_pdf' #GENERATE PDF FROM HTML
gem 'wkhtmltopdf-binary', group: :development
gem 'wkhtmltopdf-heroku', group: :production
#calendar
gem 'fullcalendar-rails' #FULLCALENDAR.IO in Rails WEBPACKER
gem 'momentjs-rails' # WEBPACKER
gem 'rjv' 
#javascript
gem "selectize-rails" #selectize.js - select or create WEBPACKER
gem "cocoon" # WEBPACKER
gem 'bootstrap-datepicker-rails' # IN CALENDAR SIDEBAR. WEBPACKER?
gem 'bootstrap4-datetime-picker-rails' #IN EVENT FORM. WEBPACKER?
#API
gem "omnicontacts" #IMPORT CONTACTS FROM GOOGLE
gem "recaptcha" #CAPTCHA. SO THAT BOTS DON'T SIGN UP. FOR PRODUCTION

group :production do
  gem 'exception_notification' #EMAIL ERRORS FOR PRODUCTION
  gem "aws-sdk-s3" #STORING FILES (IMAGES AND ATTACHMENTS). FOR PRODUCTION
end

#gem "mini_magic"
gem "icalendar" #Send calendar events to other calendar apps
gem 'rails-i18n'
#gem 'validates_timeliness', '~> 5.0.0.alpha3'
#gem 'validates_overlap'
