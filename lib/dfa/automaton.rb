require 'pry'

module DFA
  class Automaton
    attr_accessor :transitions, :states, :initial_state, :min_states, :final_state, :transition_keys

    def initialize(options = {})
      @transitions = options[:transitions] || {}
      @initial_state = options[:initial_state] || transitions.keys.first
      @final_state = options[:final_state]
      @transition_keys = @transitions.keys
      @states = {}
      setup
    end

    def minimaze!
      states_size = final_state ? states.size - 1 : states.size
      return if states_size < 2

      while states_size > 1 do
        states_size -= 1
        current_state = states.delete(state_name_with_min_edges)

        if current_state.edges[:self_referenced].any?
          minimaze_with_self_reference(current_state)
        else
          plain_minimaze(current_state)
        end
      end
    end

    private

    # merge each inbound edge with self_referenced and * by each outbound edge
    def minimaze_with_self_reference(current_state)
      current_state.edges[:inbound].each do |inbound|
        current_state.edges[:self_referenced].each do |self_referenced|
          current_state.edges[:outbound].each do |outbound|
            new_edge_value = "#{inbound.value}#{self_referenced.grouped_value}*#{outbound.grouped_value}"

            replace_states_edges(new_edge_value, inbound, outbound)
          end
        end
      end
    end

    def plain_minimaze(current_state)
      current_state.edges[:inbound].each do |inbound|
        current_state.edges[:outbound].each do |outbound|
          new_edge_value = "#{inbound.value}*#{outbound.grouped_value}"

          replace_states_edges(new_edge_value, inbound, outbound)
        end
      end
    end

    def replace_states_edges(new_edge_value, inbound, outbound)
      outbound.end_state.edges[:inbound].delete(outbound) # delete current state's edge as inbound in the destination state
      inbound.start_state.edges[:outbound].delete(inbound) # delete current state's edge as ouybound in the start state

      edge = Edge.new(new_edge_value, inbound.start_state, outbound.end_state)

      if inbound.start_state == outbound.end_state
        inbound.start_state.add_self_referenced(edge)
        inbound.start_state.merge_edges!
      else
        inbound.start_state.add_outbound(edge)
        outbound.end_state.add_inbound(edge)
        inbound.start_state.merge_edges!
        outbound.end_state.merge_edges!
      end
    end

    def state_name_with_min_edges
      scnd = states.keys[1]
      min_edges_key = states[scnd].name
      min_edges_value = states[scnd].edges_count
      states.each do |name, state|
        next if (name == final_state || name == initial_state)
        val = state.edges_count
        if val <= min_edges_value
          min_edges_value = val
          min_edges_key = name
        end
      end
      min_edges_key
    end

    def setup
      transitions.each do |state_from, edges|
        from = states[state_from] ||= State.new(state_from, initial: state_from == initial_state)
        edges.each do |state_to, edge_weight|
          to = states[state_to] ||= State.new(state_to, initial: state_to == initial_state)
          edge = Edge.new(edge_weight, from, to)

          if state_to == state_from
            from.add_self_referenced(edge)
          else
            from.add_outbound(edge)
            to.add_inbound(edge)
          end
        end
      end
    end
  end
end
