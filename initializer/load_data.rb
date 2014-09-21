if EmailJob.all.size < 100
100.times do 
 EmailJob.create!(:sender =>'mandeep.devops@gmail.com', :recipient => 'mandeep.dahiya@infibeam.net',:subject => "Yumzz#{rand(9999999)}",:message => 'Dum maaro dum')
end
end
