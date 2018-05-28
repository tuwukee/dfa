module DFA
  class Automaton
    attr_accessor :transitions, :states, :initial_state

    def initialize(options = {})
      @transitions = options[:transitions] || {}
      @initial_state = options[:initial_state] || transitions.keys.first
      @states = {}
      setup
    end

    def minimaze
      result_expression = ''
      # TODO
    end

    private

    def setup
      transitions.each do |name, outgoing_edges|
        state = State.new(name,
                          initial: name == initial_state,
                          outgoing_edges_map: outgoing_edges)
        states[name] = state
      end

      states.each do |_, state|
        state.outgoing_edges_map.each do |key, value|
          state.add_outgoing_edge(key, states[value])
        end
      end
    end
  end
end
