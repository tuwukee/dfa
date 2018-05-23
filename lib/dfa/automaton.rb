module DFA
  class Automaton
    attr_accessor :initial_state,
                  :transitions

    def initialize(options = {})
      @initial_state = options[:initial_state]
      @transitions = options[:transitions]
    end

    def minimaze
      # TODO
    end
  end
end

#  dfa = DFA::Automaton.new(initial_state: :q1,
#                           transitions:
#                           { q1: { 0 => :q1, 1 => :q2 },
#                             q2: { 0 => :q1, 1 => :q3 },
#                             q3: { 0 => :q2, 1 => :q1 }
#                           })
