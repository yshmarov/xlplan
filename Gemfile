source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
#gem 'jbuilder', github: 'rails/jbuilder'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of chromedriver to run system tests with Chrome
  gem 'chromedriver-helper'
end

#basic6
gem 'haml'                                                                      #HAML
gem "haml-rails"                                                                #HAML
gem 'bootstrap'                                                                 #BOOTSTRAP
gem 'jquery-rails'                                                              
gem 'simple_form'                                                               #SIMPLE_FORM
gem 'font-awesome-sass'                                                         #FONT_AWESOME ICONS FOR DESIGN
#calendar                                                                       
gem 'fullcalendar-rails'                                                        #FULLCALENDAR.IO in Rails
#gem 'fullcalendar-rails', github: 'EverardB/fullcalendar-rails/tree/fullcalendar-4.2.0'
#gem 'fullcalendar-rails', github: 'yshmarov/fullcalendar-rails'                
gem 'momentjs-rails'                                                            
gem 'rjv'                                                                       
#authentication & authorization
gem 'devise'                                                                    #USER AUTHENTICATION
gem 'activerecord-session_store', github: 'rails/activerecord-session_store'    
gem 'milia', '~>1.3', :git => 'https://github.com/jekuno/milia.git'             #MULTIPLE COMPANIES IN 1 PROGRAM
#gem 'milia', github: 'jekuno/milia', branch: 'issue#76'                        
gem "rolify"                                                                    #USER ROLES
gem "pundit"                                                                    #WHAT CAN USERS WITH DIFFERENT ROLES DO
#charts
gem "chartkick"                                                                 #EASY CHARTS FOR RAILS
gem 'groupdate'                                                                 #GROUPING BY PERIOD MADE EASY. NEEDED FOR CHARTKICK
#design
gem 'will_paginate'                                                             #PAGINATION
gem 'will_paginate-bootstrap4'                                                  #STYLE FOR PAGINATION
gem 'pagy'                                                                      #PAGINATION
gem 'ransack'                                                                   #SEARCH

#gem 'validates_timeliness', '~> 5.0.0.alpha3'
#gem 'validates_overlap'

gem 'money-rails'                                                               #HANDLING MONEY IN THE DATABASE
gem "selectize-rails"                                                           #
gem "cocoon"                                                                    #
gem 'public_activity', github: 'chaps-io/public_activity'                       #A SEPARATE TABLE TO SAVE THE HISTORY OF EACH "CRUD" ACTION.
gem 'friendly_id'                                                               #CUSTOM ID (NOT ALPHABETIC NUMBER)
gem 'rails-i18n'                                                                #
gem 'bootstrap-datepicker-rails'                                                #
gem 'bootstrap4-datetime-picker-rails'                                          #

group :development do
  gem 'faker'                                                                     #FILL THE DATABASE WITH FAKE DATA
end

gem "omnicontacts"                                                              #IMPORT CONTACTS FROM GOOGLE

group :production do
  gem 'exception_notification'                                                    #EMAIL ERRORS FOR PRODUCTION
end
gem 'rack-attack'                                                               #LIMIT BOT SIGN UPS. FOR PRODUCTION
#group :production do
gem "aws-sdk-s3"                                                                #STORING FILES (IMAGES AND ATTACHMENTS). FOR PRODUCTION
gem "recaptcha"                                                                 #CAPTCHA. SO THAT BOTS DON'T SIGN UP. FOR PRODUCTION
#end

gem 'wicked_pdf'                                                                #GENERATE PDF
gem 'wkhtmltopdf-binary'                                                        #ALSO NEEDED TO GENERATE PDF

#gem "mini_magic"
gem "icalendar"                                                                 #Send calendar events to other calendar appsgem 'wicked'                                                                    #turn conrollers (forms) into step-by-step wizards
gem 'wicked'                                                                    #turn conrollers (forms) into step-by-step wizards
