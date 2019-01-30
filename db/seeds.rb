PublicActivity.enabled = false

Tenant.set_current_tenant(1)

30.times do
  Client.create!([{
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone_number: Faker::PhoneNumber.cell_phone,
    #address: Faker::Address.full_address,
    email: Faker::Internet.email,
    gender: Faker::Gender.binary_type,
    date_of_birth: Faker::Date.birthday(18, 65),
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
    member_percent: Faker::Number.between(0, 90),
    repeat_reminder: Faker::Number.between(0, 90)
  }])
end

600.times do
  Event.create!([{
    starts_at: Faker::Time.between(50.days.ago, Date.today, :day),
    client_id: Faker::Number.between(1, 30),
    location_id: Faker::Number.between(1, 3),
    status: Faker::Number.between(0, 4)
  }])
end

1200.times do
  Job.create!([{
    event_id: Faker::Number.between(1, 600),
    service_id: Faker::Number.between(1, 3),
    member_id: Faker::Number.between(1, 1),
  }])
end

#1200.times do
#  InboundPayment.create!([{
#    event_id: Faker::Number.between(1, 600),
#    service_id: Faker::Number.between(1, 3),
#    member_id: Faker::Number.between(1, 1),
#  }])
#end

PublicActivity.enabled = true
