class EmailJob < ActiveRecord::Base
 def self.fetch_jobs count
  jobs = []
  while(jobs.empty?) do
   ActiveRecord::Base.transaction do
    job_ids = EmailJob.where(:transaction_id => nil).limit(count).map(&:id)
    jobs = EmailJob.where(:id => job_ids).lock(true)
    jobs.each{|job| job.update_attributes(:transaction_id => rand(9999999999))}
   end
  end
  return jobs
 end
end
