source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

gem 'rails', '~> 5.2.4.1'
gem 'pg'
gem 'puma'
gem 'sass-rails', '>= 6'
gem 'uglifier', '>= 1.3.0' #webpack in rails 6 for JS
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd' #uml; sudo apt-get install graphviz; bundle exec erd
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

#frontend
gem 'haml'                                                                      # HAML
gem "haml-rails"                                                                # convert .erb to .haml files
gem 'bootstrap'                                                                 # bootstrap
gem 'jquery-rails'                                                              # for bootstrap
gem 'simple_form'                                                               #SIMPLE_FORM
gem 'font-awesome-sass'                                                         #FONT_AWESOME ICONS FOR DESIGN
#calendar                                                                       
gem 'fullcalendar-rails'                                                        #FULLCALENDAR.IO in Rails
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

gem 'wicked_pdf'                                                                #GENERATE PDF FOR ROR
group :production do
  gem 'wkhtmltopdf-heroku', '2.12.5.0'                                          #HTML TO PDF LIBRARY
end
group :development do
  gem 'wkhtmltopdf-binary'                                                      #HTML TO PDF LIBRARY
end

#gem "mini_magic"
gem "icalendar"                                                                 #Send calendar events to other calendar appsgem 'wicked'                                                                    #turn conrollers (forms) into step-by-step wizards
gem 'wicked'                                                                    #turn conrollers (forms) into step-by-step wizards

gem 'geocoder'

gem 'devise_invitable', '~> 2.0.0'