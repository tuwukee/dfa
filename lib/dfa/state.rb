module DFA
  class State
    attr_accessor :name,
                  :initial,
                  :edges,
                  :outgoing_edges_map

    def initialize(name, options = {})
      @name = name
      @initial = options[:initial] || false
      @outgoing_edges_map = options[:outgoing_edges_map] || {}
      @edges = { outgoing: [], inbound: [] }
    end

    def add_outgoing_edge(value, end_state)
      edge = Edge.new(value, self, end_state)
      edges[:outgoing] << edge
    end
  end
end
