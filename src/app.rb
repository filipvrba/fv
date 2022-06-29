require "option_parser"
require_relative "fv"
require_relative "word"
require_relative "helper"
require_relative "arguments"

def get_file
  file = OptionParser.last_arg()
  unless file
    exit
  else
    return file
  end
end

def get_data file
  data = Array.new
  File.open(file) do |d|
    data = d.readlines
  end
  data[data.length - 1] += "\n"  # Add new line to last line

  return data
end

test()

fv = FV.new(get_data( get_file() ), 0)
fv.find_blocks(fv.data)
fv.change_blocks(fv.blocks)
fv.write_blocks(fv.blocks)

# fv.write_words(fv.words)
# fv.write_vars(fv.vars)
# fv.add_main()

p_dev( fv, @options[:is_dev])
system("python -c << END '#{fv.data.join}' END")