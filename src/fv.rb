require_relative "python"
require_relative "manipulation"
require_relative "block"

class FV < Manipulation
  attr_accessor :parent
  attr_reader :blocks, :data, :vars, :words, :dimension

  WORDS = {
    :p => "p",
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
    @words = Array.new
    @vars = Array.new
    @blocks = Array.new
    @dimension = dimension
  end

  # def find_words()
  #   @data.each_with_index do |row, i|
  #     FV::WORDS.each do |key, value|
  #       if row.index( /#{value}[ \n]/ )  # /#{value}[ \n]/
  #         @words.append Word.new(value, row, i)
  #         break
  #       end
  #     end
  
  #     @words.each do |word|
  #       name = word.get_name
  #       if name
  #         if row.include?(name) &&
  #           !row.index(/['"].*?#{name}.*?['"]/) &&  # /['"].*?\b#{name}\b.*?['"]/
  #           !row.include?(word.to_s)
  #           word.childs.append Word.new(name, row, i)
  #           break
  #         end
  #       end
  #     end

  #     FV::VARIABLES.each do |key, value|
  #       if row.include?( value )
  #         @vars.append Word.new(value, row, i)
  #       end
  #     end
  #   end
  # end

  def find_blocks(data)
    data.each_with_index do |row, i|
      FV::BLOCKS.each do |key, value|
        i_d = FV::find_word(row, value)
        if i_d and i_d == @dimension
          block = Block.new(value, row, [i, i_d])
          block.parent = self
          init_block(block)
          break
        end
      end
    end
  end

  def init_block(block)
    block.set_rows(@data.drop(block.index))
    block.init_child(@dimension)

    @blocks.append(block)
  end

  def change_blocks(blocks)
    blocks.each do |block|
      if block.child
        change_blocks( block.child.blocks )
      end

      row = block.rows[0]
      write_row = -> (value) { block.rows[0] = value }

      case block.to_s
      when FV::BLOCKS[:d]
        write_row.(Manipulation::d_p_def(block.parent.parent.to_s, row, block.get_name))
      when FV::BLOCKS[:c]
        write_row.(Manipulation::d_class(row, block.get_name))
      end
    end
  end

  def write_blocks(blocks)
    blocks.each do |block|
      block.rows.each_with_index do |row, i|
        @data[ block.get_index + i ] = row
      end

      if block.child
        write_blocks( block.child.blocks )
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