require 'thor'
require 'writefully/process'

module Writefully
  class CLI < Thor
    desc "start", "Start listening to the content directory"

    method_options %w( daemonize -d ) => :boolean

    def start(file)
      config = Writefully.config_from(file)
      
      if options.daemonize?
        ::Process.daemon(true, true)
        setup_logger(config[:logfile])
        write(::Process.pid, config[:pidfile])
        spawn(listen(config))
      else
        ::Signal.trap("INT") { $stdout.puts "Writefully exiting..."; exit }
        listen(config)
      end
    end

    desc "stop", "Stop listening for content directory changes"
    def stop(file)
      config = Writefully.config_from(file)

      pid = open(config[:pidfile]).read.strip.to_i
      ::Process.kill("HUP", pid)
      true
    rescue Errno::ENOENT
      $stdout.puts "#{pidfile} does not exist: Errno::ENOENT"
      true
    rescue Errno::ESRCH
      $stdout.puts "The process #{pid} did not exist: Errno::ESRCH"
      true
    rescue Errno::EPERM
      $stderr.puts "Lack of privileges to manage the process #{pid}: Errno::EPERM"
      false
    rescue ::Exception => e
      $stderr.puts "While signaling the PID, unexpected #{e.class}: #{e}"
      false
    end

    no_tasks do 
      def listen(config)
        Writefully::Process.instance.listen(config)
      end

      def setup_logger(logfile)
        [$stdout, $stderr].each do |io|
          File.open(logfile, 'ab') do |f|
            io.reopen(f)
          end
          io.sync = true
        end
        $stdin.reopen('/dev/null')
      end

      def write pid, pidfile
        File.open pidfile, "w" do |f| 
          f.write pid
        end
      rescue ::Exception => e
        $stderr.puts "While writing the PID to file, unexpected #{e.class}: #{e}"
        ::Process.kill "HUP", pid
      end
    end
  end
end