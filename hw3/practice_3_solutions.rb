def counting_throws
  throws_count = 10*4
  throws = throws_count.times.map { %w(H T).sample }.join('')

  h_t_t = throws.scan('HTT').count
  h_t_h = throws.scan('HTH').count

  htt_count = 0
  hth_count = 0

  repetitions = 10
  repetitions.times {
    htt_count += h_t_t
    hth_count += h_t_h
    puts "Answer after #{throws_count}:"
    puts "\th_t_t: #{h_t_t} times"
    puts "\th_t_h: #{h_t_h} times"
  }

  puts "htt average: #{1.0 * htt_count / repetitions} hth average #{ 1.0 * hth_count / repetitions}"
end
