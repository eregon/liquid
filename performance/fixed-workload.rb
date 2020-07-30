ITERATIONS = Integer(ARGV[1] || 250_000)

def bench
  t0 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  File.open('/dev/null', 'w') do |dev_null|
    File.open('/dev/urandom') do |dev_urandom|
      ITERATIONS.times do |i|
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        input = dev_urandom.readbyte
        output = yield(input)
        dev_null.puts output
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - start

        run = i + 1
        if run < 10 or run % 10000 == 0
          puts run
          puts (1.0/elapsed).floor
        end
      end
    end
  end
  t1 = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  puts "TOTAL: #{'%.3f' % (t1-t0)}s"
end

require File.expand_path(ARGV.fetch(0))
