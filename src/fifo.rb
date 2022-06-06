#!/usr/bin/ruby

class Fifo
    FILE_NAME = "signal"
    REL_PATH = "share"
    @abspath = nil

    def initialize
        @abspath = File.absolute_path(FILE_NAME, REL_PATH)
    end

    def create
        unless File.exist? @abspath
            File.mkfifo @abspath, mode=0666
        end

        @abspath
    end
    
    def post message
        f = File.new @abspath, File::WRONLY
        f.write "#{message}\n"
        f.close()
    end

    def free
        File.delete @abspath
    end
end
