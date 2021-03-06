require_relative "dispatcher"
require_relative "array"

module FV
  class BasicObject < Dispatcher
    attr_reader :id, :parent, :children
    attr_writer :id, :parent

    def initialize
      @@added_listener = -> (signal) { added_signal(signal[:object]) }

      @id = nil
      @parent = nil
      @children = Array.new
    end

    def add(object, id = nil)
      if object == self
        puts "#{self.class.name}.add: object can't be added as a child of itself."
        return self
      end

      if object
        if object.parent != nil
          object.parent.remove(object)
        end

        object.parent = self

        if object.id == nil
          object.id = id
        end

        @children.append(object)
        add_signals(object)
      else
        puts "#{self.class.name}.add: object not an instance of #{self.class.name}"
      end

      return self
    end

    def remove(object)
      index = @children.index(object)
      if index
        object.id = nil
        object.parent = nil
        @children.splice(index, 1)
      end

      return self
    end

    def free
      if @children.length > 0
        @children.each do |child|
          child.free
        end
      else
        if @parent
          free_signals()
          @parent.remove(self)
        end
      end

      if @parent
        @parent.free
      end
    end

    def free_signals
      @signals = nil
    end

    def get_scene(is_root = false)
      scene = self
      parent = scene.parent

      while true
        if is_root
          if parent == nil
            break
          end
        else
          if parent.class.name == FV::Scene::NAME_SCENE ||
             parent.class.superclass.name == FV::Scene::NAME_SCENE
            scene = parent
            break  
          end
        end

        scene = parent
        parent = scene.parent
      end

      return scene
    end

    def find_children(id)
      @children.each do |child|
        if child.id == id
          return child
        end
      end

      return nil
    end

    private
    def add_signals(object)
      # Added
      if defined?(object.ready)
        object.connect(FV::Dispatcher::ADDED, @@added_listener)
        object.emit_signal({ type: FV::Dispatcher::ADDED, object: object })
      end
    end

    def added_signal(object)
      object.ready()

      if object.id
        self.get_scene(true).emit_signal({ type: FV::Dispatcher::READY, id: object.id })
      end
    end
  end
end
