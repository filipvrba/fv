require "logger"
require_relative "./project"

class Fifo

    def initialize path, pid
        begin
            @logger = Logger.new File.join( path, "cons.log" )
            @abspath = File.join( path, pid.to_s )
        rescue Exception => e
            log e
        end
    end

    def create
        begin
            unless File.exist? @abspath
                File.mkfifo @abspath, mode=0666
            end

            return @abspath
        rescue Exception => e
            log e
            return nil
        end
    end
    
    def post message
        begin
            f = File.new @abspath, File::WRONLY
            f.write "#{message}\n"
            f.close()
        rescue Exception => e
            log e
        end
    end

    def free
        begin
            File.delete @abspath
        rescue Exception => e
            log e
        end
    end

    def log message
        @logger.error message
        puts message
    end
end
