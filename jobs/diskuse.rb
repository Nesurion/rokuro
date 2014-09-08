# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1m', :first_in => 0 do |job|
  	df = `df /media/jinn`
	diskuse_perc = df.split(" ").last(2).first.to_i
	send_event('diskusage', { value: diskuse_perc })
end
