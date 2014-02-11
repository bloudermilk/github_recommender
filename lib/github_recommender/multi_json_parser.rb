# Extremely slow parser for parsing strings that contain multiple sequential
# JSON objects
module GithubRecommender
  class MultiJsonParser
    METHODS = %w[
      start_document end_document start_object end_object start_array end_array
      key value
    ]

    def initialize(string, &on_object)
      @parser = JSON::Stream::Parser.new
      @string = string
      @on_object = on_object

      METHODS.each do |name|
        @parser.send(name, &method(name))
      end
    end

    def parse!
      @parser << @string
    end

    def start_document
      @stack = []
    end

    def end_document
      @on_object.call(@stack.pop.obj)
    end

    def start_object
      @stack.push(ObjectNode.new)
    end

    def end_object
      unless @stack.size == 1
        node = @stack.pop
        @stack[-1] << node.obj
      end
    end
    alias :end_array :end_object

    def start_array
      @stack.push(ArrayNode.new)
    end

    def key(key)
      @stack[-1] << key
    end

    def value(value)
      @stack[-1] << value
    end
  end

  class ArrayNode
    attr_reader :obj

    def initialize
      @obj = []
    end

    def <<(node)
      @obj << node
      self
    end
  end

  class ObjectNode
    attr_reader :obj

    def initialize
      @obj, @key = {}, nil
    end

    def <<(node)
      if @key
        @obj[@key] = node
        @key = nil
      else
        @key = node
      end
      self
    end
  end
end
