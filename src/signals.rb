# require "signal"

class Signals

    def initialize
        connect "USR1" do
            usr1
        end
        connect "INT" do
            int
        end
    end

    def connect name, &block
        Signal.trap( name ) do
            block.call
        end
    end

    def int
        exit 0
    end

    def usr1
        puts "own sign"
    end

    def kill name
        Process.kill name, get_pid
    end

    def get_pid
        Process.pid
    end
end
