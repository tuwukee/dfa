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
      transitions.each do |state_from, edges|
        from = states[state_from] ||= State.new(state_from, initial: state_from == initial_state)
        edges.each do |state_to, edge_weight|
          to = states[state_to] ||= State.new(state_to, initial: state_to == initial_state)
          edge = Edge.new(edge_weight, from, to)

          from.add_outbound(edge)
          to.add_inbound(edge)
        end
      end
    end
  end
end

#    dfa = DFA::Automaton.new(transitions:
#                             { q1: { q1: '0', q2: '1' },
#                               q2: { q1: '0', q3: '1' },
#                               q3: { q2: '0', q1: '1' }
#                             })