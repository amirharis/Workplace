module DNSSEC
 class Help
   def initialize
      puts "hey"
   end
 end
 class Log
   def write(msg)
    File.open("file.log", "a") do |f| 
      if f.flock(File::LOCK_EX | File::LOCK_NB)
        f.puts msg
        f.flock(File::LOCK_UN)
      else warn "Couldn't get a lock - better luck next time"
      end
    end
  end 
 end

 class Config
  def write(msg)
  File.open("named_ext.conf", "a") do |f|
      if f.flock(File::LOCK_EX | File::LOCK_NB)
        f.puts msg
        f.flock(File::LOCK_UN)
      else 
        warn "Couldn't get a lock - better luck next time"
    end
  end
  end
 end


end
