require_relative "component"
require_relative "../variable"
require_relative "../manipulation"
require_relative "../fv"

module Components
  class Variables < Component

    def self.find_var(row, var)
      return row.include?(var) &&
      !row.index(/['"].*?#{var}.*?['"]/) || # /['"].*?\b#{name}\b.*?['"]/
      row.index(/{.*#{var}.*}/)
    end
    
    def change_variables(variables)
      variables.each do |var|
        i = var.index
        row = var.row

        write_row = -> (value) { var.row = value }

        case var.to_s
        when FV::VARIABLES[:n]
          write_row.( Manipulation::d_nil(row))
        when FV::VARIABLES[:t]
          write_row.( Manipulation::d_true(row))
        when FV::VARIABLES[:f]
          write_row.( Manipulation::d_false(row))
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

    def write_variables(variables)
      variables.each do |variable|
        parent.write_data(variable.index, variable.row)
      end
    end
  end
end