require_relative "../module"
require_relative "../function"
require_relative "../manipulation"
require_relative "../fv"

module Components
  class Functions < Component
    attr_reader :names

    def initialize(parent)
      """TODO: find all functions from blocks"""
      super(parent)
      @names = Hash.new
      add_names Module.instance.functions
    end

    def add_names(hash)
      @names.merge!(hash)
    end

    def has_block?(index)
      if parent.parent
        return !parent.parent.get_block_apply_indexs().select{ |n| n == index }
      else
        return false
      end
    end

    def find_functions(data, is_block = false)
      
      puts data
      puts

      @parent.send(:find_method, data, @names, false) do |v, r, i|
        if FV::BLOCKS.select { |k, v| r.include?( v ) }.empty?
          # if has_block?(i)
            function = Function.new(v, r, i)
            function.parent = @parent
      
            @get.append(function)
            # p function
            # puts
          # end
        end
      end
    end

    def change_functions(functions)
      @parent.blocks.get.each do |block|
        if block.child
          block.child.functions.names
        end
      end

      functions.each do |func|
        i = func.index
        row = func.row

        write_row = -> value { func.row = value }

        write_row.(Manipulation::d_other(row, func.to_s))
      end
    end

    def write_functions(functions)
      functions.each do |function|
        parent.write_data(function.index, function.row)
      end
    end
  end
end