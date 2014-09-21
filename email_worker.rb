load 'initializer.rb'
module EmailWorker
 def self.start thread_count=2 , max_loaded_jobs = 5
  jobs = EmailJob.fetch_jobs(max_loaded_jobs)
  puts "job size is #{jobs.size}"
  @pool = Pool.new(thread_count)
  t=  Time.now
 puts "time is t"
  jobs.each do |job|
  puts "on job"
   @pool.schedule(job) do |job|
     email_sender = EmailSender.new job.sender,job.recipient,job.subject,job.message
     if email_sender.valid?
      if email_sender.send_mail
        ActiveRecord::Base.transaction do
         email_log = EmailLog.new(:sender => job.sender,:recipient=>job.recipient ,:subject => job.subject,:message => job.message )
         job.delete       
         email_log.save!
        end
      else
        job.update_attributes(:transaction_id => nil)
      end
     else
       ActiveRecord::Base.transaction do
         email_log = EmailLog.new(:sender => job.sender,:recipient=>job.recipient ,:subject => job.subject,:message => job.message )
         email_log.is_sent = false
         email_log.log_message =  email_sender.errors.full_messages.join(',')
         raise Exception if !job.delete 
         email_log.save!
       end
     end
   end
  end
  @pool.schedule(@pool) do |pool|
    puts "Total time taken is #{Time.now-t}"
  end
  puts "returning pool"
  @pool.shutdown
  return @pool
 end
end
