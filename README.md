pg_restore --verbose --clean --no-acl --no-owner -h localhost -d xplan_development latest.dump
#######################################################
#console commands to update counters, if needed
#Client.find_each { |client| Client.reset_counters(client.id, :jobs_count) }
#Service.find_each { |service| Service.reset_counters(service.id, :jobs_count) }
#Location.find_each { |location| Location.reset_counters(location.id, :jobs_count) }
#Employee.find_each { |member| Employee.reset_counters(member.id, :jobs_count) }
#ServiceCategory.find_each { |service_category| ServiceCategory.reset_counters(service_category.id, :services_count) }
#Client.find_each { |client| Client.reset_counters(client.id, :comments_count) }
#Location.find_each { |location| Location.reset_counters(location.id, :workplaces_count) }
#######################################################
= link_to "Back", :back
#######################################################
BAD: Instead of iterating over objects fully loaded into memory.
Tenant.map { |tenant| tenant.name }
#=> ["Eloquent Ruby", "Sapiens", "Agile Web Development With Rails"]
Tenant.map(&:name)
#=> ["Eloquent Ruby", "Sapiens", "Agile Web Development With Rails"]

GOOD: Use the ActiveRelation#pluck method to pull the required fields directly from the database.
Tenant.pluck(:name)
#=> ["Eloquent Ruby", "Sapiens", "Agile Web Development With Rails"]
#######################################################
heroku run rails c
Tenant.set_current_tenant(13)
PublicActivity.enabled = false
InboundPayment.count
InboundPayment.all.map(&:amount).sum
Tenant.current_tenant.update_attributes!(plan: "bronze")
Event.count
User.find(1)
PublicActivity::Activity.order("created_at DESC").limit(10)
InboundPayment.find_each(&:save)
rake db:drop db:create db:migrate
@user.add_role(:admin)
#######################################################
#after_create :update_start_time
def update_job_timing
  event_job_count = Job.where(event_id: job.id).count
  if event_job_count > 1
    index = event.job.index
    update_column :index, (index)
    duration_of_events_with_smaller_index = Job.where(event_id: job.id).where.not(id: self.id).where(index < self.index).map(&:duration).sum
    before_duration = duration_of_events_with_smaller_index
    job.starts_at = before_duration - event.starts_at
  else
    job.starts_at = event.starts_at
  end
  job.ends_at = job.starts_at + duration
end
#######################################################
class Transaction < ApplicationRecord
  before_create :set_slug
  private
  def set_slug
    loop do
      self.slug = SecureRandom.uuid
      break unless Transaction.where(slug: slug).exists?
    end
  end
end
#######################################################
This README would normally document whatever steps are necessary to get the
application up and running.

rails g scaffold inbound_payment tenant:references event:references client:references amount:integer payment_method:string

add_column :members, :planned_work_hours, :integer, default: 0, null: false
add_column :members, :confirmed_work_hours, :integer, default: 0, null: false
add_column :members, :cancelled_work_hours, :integer, default: 0, null: false
add_column :members, :planned_job_price, :integer, default: 0, null: false
add_column :members, :confirmed_job_price, :integer, default: 0, null: false
add_column :members, :cancelled_job_price, :integer, default: 0, null: false
add_column :members, :planned_jobs_count, :integer, default: 0, null: false
add_column :members, :confirmed_jobs_count, :integer, default: 0, null: false
add_column :members, :cancelled_jobs_count, :integer, default: 0, null: false
add_column :members, :share_of_revenue, :integer, default: 0, null: false

, class: "btn btn-primary fa fa-eye btn-sm", title: 'Show', 'data-toggle' => 'tooltip', 'data-placement' => 'top'
, class: "btn btn-warning fa fa-edit btn-sm", title: 'Edit', 'data-toggle' => 'tooltip', 'data-placement' => 'top'
, class: "btn btn-danger fa fa-trash btn-sm", title: 'Delete', 'data-toggle' => 'tooltip', 'data-placement' => 'top'

Things you may want to cover:

* Rails 5.2.3
* ruby 2.5.3p105 (2018-10-18 revision 65156) [x86_64-linux]

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

## Demo
![](https://media.giphy.com/media/yMEow45RqC8HrOmmsD/giphy.gif)