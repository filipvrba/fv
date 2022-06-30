module Components
  class Component
    attr_reader :get, :parent

    def initialize(parent)
      @parent = parent
      @get = Array.new
    end
  end
end