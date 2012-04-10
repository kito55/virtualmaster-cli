# encoding: utf-8

def callback(name, &block)
  cb = VirtualMaster::Callbacks::Callback.new(name, &block)

  VirtualMaster::CLI.callbacks << cb
end

module VirtualMaster
  module Callbacks

    class Callback
      attr_reader :name

      def initialize(name, &block)
        @name = name
        @blocks = {}
        @auto_run = true
        @option = nil
        
        instance_eval &block
      end

      def before(event, &block)
        store_callback(event, :before, &block)
      end

      def after(event, &block)
        store_callback(event, :after, &block)
      end

      def option(trigger)
        # disable auto_run when option provided
        @auto_run = false

        @option = trigger
      end

      def fire(event, phase, options, server)
        @blocks[event][phase].call(server) if includes?(event, phase) && (@auto_run || options[@option] == true)
      end

      def to_s
        @blocks.inspect
      end

    private

      def includes?(event, phase)
        @blocks.include?(event) && @blocks[event].include?(phase)
      end

      def store_callback(event, phase, &block)
        callbacks = @blocks[event] || {}

        callbacks[phase] = block

        @blocks[event] = callbacks
      end
    end

    def self.load_file(file)
      load file
    end

    def self.trigger_event(event, phase, options, server = {})
      CLI.callbacks.each do |callback|
        callback.fire(event, phase, options, server)
      end
    end
  end
end