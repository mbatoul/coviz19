# frozen_string_literal: true

# Module used to build a service.
#
# Example usage :
# ```
#   class SayHello
#     include Service
#     attr_accessor :name
#
#     def call
#       puts "Hello #{name} !"
#     end
#   end
#
#   SayHello.call(name: "toto")
# ```
#

module Service
  extend ActiveSupport::Concern

  included do
    # Proxy to #call instance method
    def self.call(*args)
      new(*args).call
    end

    # Service initializer
    def initialize(args={})
      raise ArgumentError, "provided 'args' should be a hash." unless args.is_a?(Hash)

      args.each { |k, v| send("#{k}=", v) }
    end

    # Wait for a collection to be commited before executing the given block.
    # Requires ActiveRecord::InstanceCallbacks
    def after_commit_all(collection)
      committed = Set.new
      lock = Mutex.new
      collection.each do |item|
        item.after_commit do
          lock.synchronize do
            committed.add(item)
            yield if committed.size >= collection.size
          end
        end
      end
    end
  end
end
