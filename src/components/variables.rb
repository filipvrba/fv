require_relative "component"

module Components
  class Variables < Component

    def self.find_var(row, var)
      return row.include?(var) &&
      !row.index(/['"].*?#{var}.*?['"]/) || # /['"].*?\b#{name}\b.*?['"]/
      row.index(/{.*#{var}.*}/)
    end

    def change_variables(block, &callback)
      block.child.variables.get.each do |var|
        i = var.index
        row = block.rows[i]
  
        case var.to_s
        when FV::VARIABLES[:n]
          callback.call Manipulation::d_nil(row), i
        when FV::VARIABLES[:t]
          callback.call Manipulation::d_true(row), i
        when FV::VARIABLES[:f]
          callback.call Manipulation::d_false(row), i
        end
      end
    end

    def find_variables(data)
      @parent.send(:find_method, data, FV::VARIABLES, false) do |v, r, i|
        variable = Variable.new(v, r, i)
        variable.parent = @parent
  
        @get.append(variable)
      end
    end
  end
end