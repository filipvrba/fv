require_relative "./signals"
require_relative "./fifo"
require "json"

class Share < Signals
    attr_reader :path, :fifo

    def initialize
        super

        set_path "share"
        @fifo = Fifo.new File.join( path, get_pid.to_s )
    end

    def set_path value
        _path = File.realpath( '../..', __FILE__ )
        @path = File.join( _path, value )
    end

    def p_path is_shared
        if is_shared
            puts @path
            kill "INT"
        end
    end

    def usr1
        @fifo.create
        json = {:name => "filip"}.to_json
        @fifo.post json
        @fifo.free
    end
end
