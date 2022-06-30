require_relative "python"
require_relative "manipulation"
require_relative "variable"
require_relative "components/blocks"
require_relative "components/variables"

class FV < Manipulation
  attr_accessor :parent
  attr_reader :blocks, :data, :variables, :words, :dimension

  WORDS = {
    :i => "<"
  }

  VARIABLES = {
    :n => "nil",
    :f => "false",
    :t => "true"
  }

  CONTROLS = {
    :i => "if",
    :e => "else",
    :ei => "elif"
  }

  METHODS = {
    :m => "main"
  }

  BLOCKS = {
    :d => "def",
    :c => "class",
    :i => "if",
  }
  BLOCKS_END = {
    :e => "end"
  }
  DIMENSION = 2

  def self.find_word(row, word)
    row.index( /#{word}[ \n]/ )
  end

  def initialize(data, dimension)
    @data = data
    @dimension = dimension

    #@words = Array.new
    @variables = Components::Variables.new(self)
    @blocks = Components::Blocks.new(self)
  end

  def find_method(data, keys, has_d = true, &callback)
    data.each_with_index do |row, i|
      keys.each do |key, value|
        if has_d
          i_d = FV::find_word(row, value)
          if i_d and i_d == @dimension
            callback.call(value, row, [i, i_d])
            break
          end
        else
          if Components::Variables::find_var(row, value)
            callback.call(value, row, i)
            break
          end
        end
      end
    end
  end

#     else
#         Other for method
#         write_row.(Manipulation::d_other(row, word.to_s))
#     end
  
  def add_main()
    name = FV::METHODS[:m].concat("():")
    @data.each do |r|
      if r.include?( name )
        @data[@data.length - 1] += Manipulation::d_main()
        break
      end
    end
  end
end
