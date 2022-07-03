require_relative "array"

module FV
  class Dispatcher
    attr_reader :signals

    ADDED = "added"
    READY = "ready"

    def initialize
      @signals = nil
    end

    def connect(type, signal)
      if @signals == nil
        @signals = Hash.new
      end

      signals = @signals

      if signals[type] == nil
        signals[type] = Array.new
      end

      if signals[type].index(signal) == nil
        signals[type].append(signal)
      end
    end

    def disconnect(type, signal)
      if @signals == nil
        return
      end

      signals = @signals
      signal_array = signals[type]

      if signal_array != nil
        index = signal_array.index(signal)

        if index != nil
          signal_array.splice(index, 1)
        end
      end
    end

    def has_signal(type, listener)
      if @signals == nil
        return
      end

      listeners = @signals
      return listeners[type] != nil &&
        listeners[type].index(listener) != nil
    end

    def emit_signal(signal)
      if @signals == nil
        return
      end

      signals = @signals
      signal_array = signals[signal[:type]]

      if signal_array != nil
        signal[:target] = self

        array = signal_array  # signal_array.slice(0)
        array.each do |sig_prog|
          sig_prog.call(signal)
        end

        signal[:target] = nil
      end
    end
  end
end