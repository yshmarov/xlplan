json.array! @jobs, partial: 'jobs/job', as: :job

json.array!(@jobs) do |job|
  json.extract! job, :id, :description
  json.start job.starts_at
  json.end job.ends_at
  json.url job_url(job, format: :html)
end