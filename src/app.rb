require_relative "./share"

def get_value option
    index = ARGV.index(option) + 1
    ARGV[index]
end

def process_argv(option)
    case option
    when "-h", "--help"
        puts "# FIFO Virtual"
        puts "Is place for multiple languages program communications."
        puts ""
        puts "## Arguments:"
        puts "    -s, --share    Get a share directory."
        exit
    when "-s", "--share"
        @options[:share] = true
    end
end

@options = {}
ARGV.each do |option|
    process_argv(option)
end

share = Share.new
share.p_path @options[:share]

puts share.get_pid
while true
    sleep 1
end
