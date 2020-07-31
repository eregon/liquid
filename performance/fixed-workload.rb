ITERATIONS = Integer(ARGV[1] || 250_000)

def bench
  t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  max = 0
  File.open('/dev/null', 'w') do |dev_null|
    File.open('/dev/urandom') do |dev_urandom|
      ITERATIONS.times do |i|
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        input = dev_urandom.readbyte
        output = yield(input)
        dev_null.puts output
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start

        ips = (1.0/elapsed).floor
        max = ips if ips > max

        run = i + 1
        if run < 10 or run % 10000 == 0
          puts "#{run.to_s.rjust(6)} #{ips}"
        end
      end
    end
  end
  t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  total = t1 - t0
  puts "TOTAL: #{'%.3f' % total} s, avg #{(ITERATIONS/total).to_i} i/s, max #{max} i/s"
end

require File.expand_path(ARGV.fetch(0)) if ARGV.size >= 1
