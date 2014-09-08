# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
def get_cputemp
	temp1 = File.readlines("/sys/bus/platform/devices/coretemp.0/temp2_input","r")
	temp2 = File.readlines("/sys/bus/platform/devices/coretemp.0/temp3_input","r")
	temp = ((temp1[0].to_i / 1000 ) + (temp2[0].to_i / 1000 )) /2
	return temp
end
points = [{x:0, y:get_cputemp}]
last_x = points.last[:x]
hour_pased = false
SCHEDULER.every '60s', :first_in => 0 do |job|
  if last_x == 60
	day_pased = true
  end
  if hour_pased
	points.shift
  end
  last_x += 1
  points << { x: last_x, y: get_cputemp }
  send_event('cputemp', points: points)
end
