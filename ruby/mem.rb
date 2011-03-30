require 'dalli'
dc = Dalli::Client.new('localhost:11211')
dc.set('abc', 123)
value = dc.get('abc')
