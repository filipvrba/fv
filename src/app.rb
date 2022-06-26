require "option_parser"
require_relative "fv"
require_relative "word"
require_relative "helper"

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

@data = Array.new
File.open(file) do |d|
  @data = d.readlines
end
@data[@data.length - 1] += "\n"

fv = FV.new
fv.find_words(@data)

# change row from words
def write_words(arr)
  arr.each do |word|
    row = @data[word.index]
    write_row = -> (value, i = 0) { @data[word.index - i] = value }
    case word.to_s
    when FV::WORDS[:d]
      write_row.(FV::d_def(row, word.get_name))
    when FV::WORDS[:c]
      write_row.(FV::d_class(row, word.get_name))
    when FV::WORDS[:p]
      write_row.(FV::d_p(row))
    when FV::WORDS[:e]
      data = @data[word.index - 1]
      write_row.(FV::d_end(row, data))
    else
      write_row.(FV::d_other(row, word.to_s))
    end

    if word.childs.length > 0
      write_words( word.childs )
    end
  end
end

def add_main()
  name = FV::METHODS[:m].concat("():")
  @data.each do |r|
    if r.include?( name )
      @data[@data.length - 1] += FV::d_main()
      break
    end
  end
end

write_words(fv.words)
add_main()

p_header("Python")
puts @data
p_header("App")
system("python -c << END '#{@data.join}' END")