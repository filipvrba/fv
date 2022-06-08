module App
    class Arguments
        attr_reader :options

        HELP = "-h, --help"
        SHARE = "-s, --share"
        MESSAGE = "-m, --message"

        def initialize
            @options = {}
            ARGV.each do |option|
                process_argv(option)
            end
        end

        def get_value option
            index = ARGV.index(option) + 1
            ARGV[index]
        end
        
        def ars arg
            arg.split(', ')
        end

        def process_argv(option)
            case option
            when ars(HELP)[0], ars(HELP)[1]
                puts "# FIFO Virtual"
                puts "Is place for multiple languages program communications."
                puts ""
                puts "## Arguments:"
                Project.puts_argument_info SHARE, "Get a share directory."
                Project.puts_argument_info MESSAGE, "Set message for an pipeline."
                exit
            when ars(SHARE)[0], ars(SHARE)[1]
                @options[:share] = true
            when ars(MESSAGE)[0], ars(MESSAGE)[1]
                @options[:message] = get_value option
            end
        end
    end
end