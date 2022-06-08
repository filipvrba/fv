class Fifo

    def initialize path_pid
        @abspath = path_pid
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
