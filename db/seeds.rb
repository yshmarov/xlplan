# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Category.create!(name: 'For Men')
Category.create!(name: 'For Women')
Service.create!(name: 'Haircut', description: 'Male bold', duration: 60, client_price: 250, employee_percent: 50, employee_price: 120, quantity: 1, status: 0, category_id: 1)
Service.create!(name: 'Nail polishing', description: '', duration: 30, client_price: 400, employee_percent: 50, employee_price: 120, quantity: 1, status: 0, category_id: 2)
Location.create!(name: 'Pyat', tel: 675760, balance: 0, status: 0)
Machine.create!(name: 'M1', location_id: 1, status: 0)
Person.create!(first_name: 'Yaro', last_name: 'Shm', status: 0)

