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

# find default words
# e.c. def add to list
# find uses def
fv = FV.new

data.each_with_index do |row, i|
  FV::WORDS.each do |key, value|
    if row.include?(value)
      fv.words.append Word.new(value, row, i)
      break
    end
  end

  fv.words.each do |word|
    name = word.get_name
    if name
      if row.include?(name) &&
        !row.include?(word.to_s)
        word.childs.append Word.new(name, row, i)
        break
      end
    end
  end
end

fv.words.each do |word|
  word.childs.each do |child|
    p child
  end
end