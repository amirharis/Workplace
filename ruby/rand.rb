require 'digest/md5'

def rand_name(len=5)
  ary = [('0'..'9').to_a, ('a'..'z').to_a, ('A'..'Z').to_a]
  name = ''

  len.times do
    name << ary.sample.sample
  end
  name
end

puts "http://j.my/#{rand_name}"
puts "http://go.my/#{rand_name}"
puts "http://me.my/#{rand_name}"
puts Digest::MD5.hexdigest("http://j.my/#{rand_name}")
