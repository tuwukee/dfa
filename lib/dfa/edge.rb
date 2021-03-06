module DFA
  class Edge
    attr_accessor :value, :start_state, :end_state

    def initialize(value, start_state, end_state)
      @value = value
      @start_state = start_state
      @end_state = end_state
    end

    def outbound?(state)
      start_state == state
    end

    def inbound?(state)
      end_state == state
    end

    def self_referenced?
      end_state == start_state
    end

    def grouped_value
      value.size > 1 ? "(#{value})" : value
    end
  end
end
