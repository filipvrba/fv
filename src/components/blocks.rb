require_relative "../block"
require_relative "../manipulation"
require_relative "../fv"
require_relative "component"

module Components
  class Blocks < Component
    def self.blocks_end_noempty_row(rows)
      rows.each do |r|
        if !r.strip.empty? and !r.index(/#{FV::BLOCKS_END[:e]}/)
          return r
        end
      end
      return nil
    end

    def init_block(block)
      block.set_rows(parent.data.drop(block.index))
      block.init_child(parent.dimension)
  
      @get.append(block)

      if block.to_s == FV::BLOCKS[:d] or block.to_s == FV::BLOCKS[:c]
        n = block.get_name
        @parent.functions.send(:add_names, {"#{block.to_s}.#{n}" => n})
      end
    end

    def find_blocks(data)
      parent.send(:find_method, data, FV::BLOCKS) do |v, r, ids|
        block = Block.new(v, r, ids)
        block.parent = @parent
        init_block(block)
      end
    end

    def change_blocks(blocks)
      blocks.each do |block|
        if block.child
          change_blocks( block.child.blocks.get )
        end
  
        row = block.rows[0]
        write_row = -> (value, index = 0) { block.rows[index] = value }
  
        case block.to_s
        when FV::BLOCKS[:d]
          write_row.(Manipulation::d_p_def(block.parent.parent.to_s, row, block.get_name))
        when FV::BLOCKS[:c]
          write_row.(Manipulation::d_class(row, block.get_name))
        when FV::BLOCKS[:i]
          block.rows.each_with_index do |r, i|
            write_row.(Manipulation::d_if(block.rows, i), i)
          end
        end
  
        change_blocks_end(block) do |r, i|
          write_row.(r, i)
        end
      end
    end

    def change_blocks_end(block, &callback)
      index = block.rows.length - 1
      row_d = block.rows[index]
      row_u = Blocks::blocks_end_noempty_row(block.rows.reverse)
  
      if row_u
        callback.call Manipulation.d_end( row_d, row_u ), index
      end
    end

    def write_blocks(blocks)
      blocks.each do |block|
        block.rows.each_with_index do |row, i|
          parent.data[ block.get_index + i ] = row
        end
  
        if block.child
          write_blocks( block.child.blocks.get )
        end
      end
    end
  end
end