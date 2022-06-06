require "./src/blackbox.rb"

@blackbox = Blackbox.new

def get_value option
    index = ARGV.index(option) + 1
    ARGV[index]
end

def process_argv(option)
    case option
    when "-h", "--help"
        puts "# This is the help menu."
        puts "This app by added new signals for a blackbox."
        puts ""
        puts "-p, --pid  [pid]     Set pid for a blackbox"
        puts "-n, --name [name]    Set name for orientation a pid"
        puts "-f, --free [pid]     Remove pid from a blackbox"
        exit
    when "-p", "--pid"
        @options[:pid] = get_value option
    when "-n", "--name"
        @options[:name] = get_value option
    when "-f", "--free"
        @blackbox.free (get_value option)
        exit
    end
end

@options = {:pid=>nil, :name=>nil}
ARGV.each do |option|
    process_argv(option)
end

@blackbox.add @options[:pid], @options[:name]