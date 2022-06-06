#!/usr/bin/ruby
require "./src/project.rb"

class Fifo
    @abspath = nil

    def initialize pid
        @abspath = get_abspath pid
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
