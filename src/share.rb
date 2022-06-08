require_relative "./signals"
require_relative "./fifo"
require_relative "./project"
require "json"

class Share < Signals
    attr_reader :path, :fifo

    def initialize message
        super()

        @path = Project.get_abs_path "share"
        @fifo = Fifo.new @path, get_pid
        @message = message
    end

    def p_path is_shared
        if is_shared
            p @path
            kill "INT"
        end
    end

    def usr1
        p @fifo.create
        @fifo.post @message
        @fifo.free
        kill "INT"
    end
end
