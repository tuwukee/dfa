# frozen_string_literal: true

require 'test_helper'
require 'pry'

class AutomatonTest < Minitest::Test
  def test_assigns_states
    dfa = DFA::Automaton.new(transitions:
                             { q1: { '0' => :q1, '1' => :q2 },
                               q2: { '0' => :q1, '1' => :q3 },
                               q3: { '0' => :q2, '1' => :q1 }
                             })
    assert dfa.states[:q1].edges[:outgoing].first.value, '0'
    assert dfa.states[:q1].edges[:outgoing].first.start_state, dfa.states[:q1]
    assert dfa.states[:q1].edges[:outgoing].first.end_state, dfa.states[:q1]
    assert dfa.states[:q1].edges[:outgoing].last.value, '1'
    assert dfa.states[:q1].edges[:outgoing].last.start_state, dfa.states[:q1]
    assert dfa.states[:q1].edges[:outgoing].last.end_state, dfa.states[:q2]
    assert dfa.states[:q2].edges[:outgoing].first.value, '0'
    assert dfa.states[:q2].edges[:outgoing].first.start_state, dfa.states[:q2]
    assert dfa.states[:q2].edges[:outgoing].first.end_state, dfa.states[:q1]
    assert dfa.states[:q2].edges[:outgoing].last.value, '1'
    assert dfa.states[:q2].edges[:outgoing].last.start_state, dfa.states[:q2]
    assert dfa.states[:q2].edges[:outgoing].last.end_state, dfa.states[:q3]
    assert dfa.states[:q3].edges[:outgoing].first.value, '0'
    assert dfa.states[:q3].edges[:outgoing].first.start_state, dfa.states[:q3]
    assert dfa.states[:q3].edges[:outgoing].first.end_state, dfa.states[:q2]
    assert dfa.states[:q3].edges[:outgoing].last.value, '1'
    assert dfa.states[:q3].edges[:outgoing].last.start_state, dfa.states[:q3]
    assert dfa.states[:q3].edges[:outgoing].last.end_state, dfa.states[:q1]
  end
end
