PublicActivity.enabled = false
Location.create!(name: 'Location-1', tel: 675760, balance: 0, status: 1)
Employee.create!(first_name: 'Yaro', last_name: 'Shm', email: 'yshmarov@gmail.com', location_id: 1)
User.create!(employee_id: 1, email:'yshmarov@gmail.com', password: 'yshmarov@gmail.com', confirmed_at: DateTime.now)

#current_user = User.first

Workplace.create!(name: 'Workplace-1', location_id: 1)
Client.create!(first_name: 'Yuliia', last_name: 'Zapetaya', email: 'zapetaya.y@gmail.com', employee_id: 1)
Client.create!(first_name: 'Iryna', last_name: 'Sharovarova', email: 'irina@gmail.com', employee_id: 1)
Client.create!(first_name: 'Oleksiy', last_name: 'Seleznev', email: 'alex@gmail.com', employee_id: 1)
Client.create!(first_name: 'Elena', last_name: 'Fedorova', email: 'elena@gmail.com', employee_id: 1)
ServiceCategory.create!(name: 'Category-1')
ServiceCategory.create!(name: 'Category-2')
Service.create!(name: 'Haircut', description: 'Male bold', duration: 60, client_price_cents: 250, employee_percent: 50, employee_price: 17, quantity: 1, status: 0, service_category_id: 1)
Service.create!(name: 'Nail polishing 1', description: 'laminate', duration: 60, client_price_cents: 400, employee_percent: 50, employee_price: 17, quantity: 1, status: 1, service_category_id: 2)
Service.create!(name: 'Nail polishing 2', description: 'classic', duration: 30, client_price_cents: 200, employee_percent: 50, employee_price: 17, quantity: 1, status: 0, service_category_id: 2)
Skill.create!(employee_id:1, service_category_id:1)
Skill.create!(employee_id:1, service_category_id:2)
Job.create!(client_id: 1, employee_id: 1, location_id: 1, service_id: 1, created_by: 1, status: 1, starts_at: Time.now-1.hour)
Job.create!(client_id: 1, employee_id: 1, location_id: 1, service_id: 2, created_by: 1, status: 1, starts_at: Time.now+1.hour)
Job.create!(client_id: 2, employee_id: 1, location_id: 1, service_id: 3, created_by: 1, starts_at: Time.now+2.hours)
Job.create!(client_id: 3, employee_id: 1, location_id: 1, service_id: 2, created_by: 1, starts_at: Time.now+2.hours)
PublicActivity.enabled = true
