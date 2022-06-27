@options = { is_dev: -1 }

OptionParser.parse do |parser|
  parser.banner( "Usage: fv [options] [program file]\n\nOptions:" )
  parser.on( "-h", "--help", "Show help" ) do
      puts parser
      exit
  end
  parser.on( "-v", "--version", "Show version" ) do
    puts "Version is 1.0.0"
    exit
  end
  parser.on( "-d ID", "--dev ID", "Show all development an messages." ) do |id|
    is_int = id.to_i.to_s == id
    if is_int
      @options[:is_dev] = id
    else
      @options[:is_dev] = 0
    end
  end
end