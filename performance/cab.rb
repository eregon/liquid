def bench
  File.open('/dev/null', 'w') do |dev_null|
    File.open('/dev/urandom') do |dev_urandom|
      ips_log = []
      iterations = 1
      loop do
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        iterations.times do
          input = dev_urandom.readbyte
          output = yield(input)
          dev_null.puts output
        end
        elapsed = start = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
        ips = iterations / elapsed
        ips_log.push ips
        ips_log.shift if ips_log.size > 10
        printf "%4.2f ips, %4.2f avg\n", ips, ips_log.sum / ips_log.size
        iterations = ips.to_i
      end
    end
  end
end
