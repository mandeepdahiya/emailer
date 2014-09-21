load "email_worker.rb"
thread_count = 2
max_loaded_jobs = 5
if ARGV[0]  && ARGV[0].match(/^[0-9]$/) && ARGV[1] && ARGV[1].match(/^[0-9]$/)
 thread_count  = ARGV[0]
 max_loaded_jobs =  ARGV[1]
 EmailWorker.start(thread_count.to_i,max_loaded_jobs.to_i)
else
 puts "You can  input first argument thread_count max limit is 9 default value is 2"
 puts "Also you can input second argument maximum number of jobs that can be loaded in memory default value is 5"
 EmailWorker.start(thread_count,max_loaded_jobs)
end
