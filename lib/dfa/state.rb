module DFA
  class State
    attr_accessor :name,
                  :initial,
                  :edges

    def initialize(name, options = {})
      @name = name
      @initial = options[:initial] || false
      @edges = { outbound: [], inbound: [] }
    end

    def add_outbound(edge)
      edges[:outbound] << edge
    end

    def add_inbound(edge)
      edges[:inbound] << edge
    end
  end
end
