# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
current_mem=0

#method to read specific line
def read_line_number(filename, number)
  return nil if number < 1
  line = File.readlines(filename)[number-1]
  line ? line.chomp : nil
end

SCHEDULER.every '2s', :first_in => 0 do |job|
  last_mem = current_mem
  memtotal = read_line_number("/proc/meminfo", 1)
  memactive = read_line_number("/proc/meminfo", 6)

  memtotal = memtotal.split(" ").last(2).first.to_i
  memactive = memactive.split(" ").last(2).first.to_i

  current_mem = ((memactive.to_f / memtotal.to_f) * 100).to_i

  send_event('memuse', { current: current_mem, last:  last_mem})
end
