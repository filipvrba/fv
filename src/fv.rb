require_relative "python"
require_relative "manipulation"

class FV < Manipulation
  attr_reader :data, :vars, :words

  WORDS = {
    :d => "def",
    :c => "class",
    :p => "p",
    :e => "end",
    :i => "<"
  }

  VARIABLES = {
    :n => "nil",
    :f => "false",
    :t => "true"
  }

  METHODS = {
    :m => "main"
  }

  def initialize(data)
    @data = data
    @words = Array.new
    @vars = Array.new
  end

  def find_words()
    @data.each_with_index do |row, i|
      FV::WORDS.each do |key, value|
        if row.index( /#{value}[ \n]/ )  # /#{value}[ \n]/
          @words.append Word.new(value, row, i)
          break
        end
      end
  
      @words.each do |word|
        name = word.get_name
        if name
          if row.include?(name) &&
            !row.index(/['"].*?#{name}.*?['"]/) &&  # /['"].*?\b#{name}\b.*?['"]/
            !row.include?(word.to_s)
            word.childs.append Word.new(name, row, i)
            break
          end
        end
      end

      FV::VARIABLES.each do |key, value|
        if row.include?( value )
          @vars.append Word.new(value, row, i)
        end
      end
    end
  end

  def write_words(arr)
    arr.each do |word|
      row = @data[word.index]
      write_row = -> (value, i = 0) { @data[word.index - i] = value }
      case word.to_s
      when FV::WORDS[:d]
        write_row.(Manipulation::d_def(row, word.get_name))
      when FV::WORDS[:c]
        write_row.(Manipulation::d_class(row, word.get_name))
      when FV::WORDS[:p]
        write_row.(Manipulation::d_p(row))
      when FV::WORDS[:e]
        data = @data[word.index - 1]
        write_row.(Manipulation::d_end(row, data))
      when FV::WORDS[:n]
        write_row.(Manipulation::d_nil(row))
      when FV::WORDS[:f]
        write_row.(Manipulation::d_false(row))
      when FV::WORDS[:t]
        write_row.(Manipulation::d_true(row))
      else
          write_row.(Manipulation::d_other(row, word.to_s))
      end
  
      if word.childs.length > 0
        write_words( word.childs )
      end
    end
  end
  
  def write_vars(arr)
    arr.each do |vars|
      row = @data[vars.index]
      write_row = -> (value, i = 0) { @data[vars.index - i] = value }
      case vars.to_s
      when FV::VARIABLES[:n]
        write_row.(Manipulation::d_nil(row))
      when FV::VARIABLES[:f]
        write_row.(Manipulation::d_false(row))
      when FV::VARIABLES[:t]
        write_row.(Manipulation::d_true(row))
      end
    end
  end
  
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