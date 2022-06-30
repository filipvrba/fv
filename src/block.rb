require 'securerandom'
require_relative "word"

class Block < Word
  attr_accessor :parent
  attr_reader :index_dimension, :rows, :child, :uuid

  def initialize(word, row, indexs)
    super(word, row, indexs[0])
    @uuid = SecureRandom.uuid
    @index_dimension = indexs[1]
    @rows = []
    @child = nil
  end

  def get_index()
    if parent && parent.parent
      i_p = parent.parent.index + @index
    else
      @index
    end
  end

  def set_rows(data)
    data_loop(data) do |row|
      @rows << row
    end
  end

  def data_loop(data, &callback)
    data.each do |row|
      callback.call(row)

      i_e = FV::find_word(row, FV::BLOCKS_END[:e])
      if i_e and i_e == @index_dimension
        break
      end
    end
  end

  def init_child(dimension)
    @child = FV.new(@rows, dimension + FV::DIMENSION)
    @child.parent = self
    @child.find_blocks( @child.data )
    @child.find_variables( @child.data )

    # if @child.blocks.empty?
    #   @child = nil
    # end
  end
end