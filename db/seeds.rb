PublicActivity.enabled = false
t = Tenant.first_or_create({
 name: 'Nika Beauty',
 plan: 'max',
 default_currency: 'uah',
 locale: 'ru'
})
t.save!
Tenant.set_current_tenant(1)
first_user = User.create!(email: 'yshmarov@gmail.com', password: 'yshmarov@gmail.com', password_confirmation: 'yshmarov@gmail.com')
Member.create!(first_name: "Albert", last_name: "Einstein", user_id: first_user.id)
first_user.add_role(:admin)
second_user = User.create!(email: 'admin@example.com', password: 'admin@example.com', password_confirmation: 'admin@example.com')
Member.create!(first_name: "Nicola", last_name: "Tesla", user_id: second_user.id)
30.times do
  Client.create!([{
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number: Faker::PhoneNumber.cell_phone,
    #address: Faker::Address.full_address,
    email: Faker::Internet.email,
    gender: Faker::Gender.binary_type,
    date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 65)
  }])
end
3.times do
  Location.create!([{
    name: Faker::Address.unique.city,
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.cell_phone,
    email: Faker::Internet.email
  }])
end
ServiceCategory.create!(name: 'For Men')
ServiceCategory.create!(name: 'For Women')
ServiceCategory.create!(name: 'For Children')
3.times do
  Service.create!([{
    name: Faker::Job.unique.field,
    service_category_id: Faker::Number.between(1, 3),
    description: Faker::Job.field,
    duration: Faker::Number.between(15, 120),
    client_price: Faker::Number.between(1000, 90000),
    member_percent: Faker::Number.between(0, 90)
  }])
end
###EVENTS WITH DIFFERENT STATUSES###
25.times do
  Event.create!([{
    starts_at: Faker::Time.between(from: 150.days.ago, to: Date.today),
    client_id: Client.first.id,
    workplace_id: Workplace.first.id,
    status: "confirmed"
  }])
end
250.times do
  Event.create!([{
    starts_at: Faker::Time.between(from: 150.days.ago, to: Date.today),
    client_id: Client.first.id,
    workplace_id: Workplace.first.id,
    status: "confirmed"
  }])
end
25.times do
  Event.create!([{
    starts_at: Faker::Time.between(from: 150.days.ago, to: Date.today),
    client_id: Client.first.id,
    workplace_id: Workplace.first.id,
    status: "confirmed"
  }])
end
###END EVENTS###
600.times do
  Job.create!([{
    event_id: Faker::Number.between(Event.first.id, Event.last.id),
    service_id: Faker::Number.between(1, 3),
    member_id: Member.first.id,
  }])
end
300.times do
  Transaction.create!([{
    client_id: Faker::Number.between(1, 30),
    amount: Faker::Number.between(1000, 90000),
    cash_account: CashAccount.first,
  }])
end
PublicActivity.enabled = true
