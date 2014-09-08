# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '2s', :first_in => 0 do |job|
	proc0 = File.readlines('/proc/stat').grep(/^cpu /).first.split(" ")
	sleep 1
	proc1 = File.readlines('/proc/stat').grep(/^cpu /).first.split(" ")

	proc0usagesum = proc0[1].to_i + proc0[2].to_i + proc0[3].to_i
	proc1usagesum = proc1[1].to_i + proc1[2].to_i + proc1[3].to_i
	procusage = proc1usagesum - proc0usagesum

	proc0total = 0
	  for i in (1..4) do
	      proc0total += proc0[i].to_i
	    end
	proc1total = 0
	    for i in (1..4) do
	      proc1total += proc1[i].to_i
	    end
	proctotal = (proc1total - proc0total)

	cpuusage = (procusage.to_f / proctotal.to_f)
	cpuusagepercentage = (100 * cpuusage).to_f.round(2) 
 send_event('cpu', { value: cpuusagepercentage })
end
