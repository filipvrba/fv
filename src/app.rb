require "option_parser"
require_relative "fv"
require_relative "word"

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
end

file = OptionParser.last_arg()
unless file
  exit
end

data = Array.new
File.open(file) do |d|
  data = d.readlines
end

fv = FV.new
fv.find_words(data)

fv.words.each do |word|
  p word
end