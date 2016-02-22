class SnapListener
  def initialize
    @threads = []
    @playersnap = false
  end
    
  attr_accessor :threads, :playersnap
  
  def win32_api
    require 'Win32API'
    $win32_console_kbhit = Win32API.new("msvcrt", "_kbhit", [], 'I')
    # $win32_console_rewind = Win32API.new("msvcrt", "rewind", ['P']) # v unsure as to the import array and export settings. MS say rewind returns nothing
      
    def wipe_buffer
      puts "BEFORE REWIND"
      $win32_console_rewind.call('stdin') # this crashes out - not sure why
      puts "AFTER REWIND" 
    end
      
    def console_input_ready?
      $win32_console_kbhit.call != 0
    end
      
    def nonblocking_stdin_gets
      sleep(0.1) until console_input_ready?
      puts "GET HERE"
      $stdin.gets  # don't bother to use getc, it also blocks until user hits <return>
    end
  end

  def listen_for_snap
    # wipe_buffer
    
    @threads << Thread.new {
      while true
        input = nonblocking_stdin_gets
        if input == "\n"
          puts "HUMAN SNAP!"
          @playersnap = true
          @threads[1].kill
          @threads[0].kill
        end
      end
    }

    @threads << Thread.new {
        25.times do |t|
        print "."
        sleep(0.1)
      end
      
      @threads.each {|thr| thr.kill}
    }

 
  threads.each {|thr| thr.join}
  
  puts "HUMAN SNAPPED" if playersnap == true
  puts "COMPUTER SNAPPED" unless playersnap == true
  puts threads[0].alive?
  puts threads[1].alive?
  return playersnap
  end
end
