class Project
    def self.get_abs_path value
        path = File.realpath( '../..', __FILE__ )
        return File.join( path, value )
    end

    def self.puts_argument_info arg, message
        puts "".ljust(4) + arg.ljust(20) + message
    end
end