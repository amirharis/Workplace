alphanumerics = [('0'..'9'),('A'..'Z'),('a'..'z')].map {|range| range.to_a}.flatten
a = (0...7).map { alphanumerics[Kernel.rand(alphanumerics.size)] }.join
b = (0...7).collect { alphanumerics[Kernel.rand(alphanumerics.length)] }.join
puts a
puts b
