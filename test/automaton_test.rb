# frozen_string_literal: true

require 'test_helper'
require 'pry'

class AutomatonTest < Minitest::Test
  def test_assigns_states_and_edges
    dfa = DFA::Automaton.new(transitions:
                             { q1: { q1: '0', q2: '1' },
                               q2: { q1: '0', q3: '1' },
                               q3: { q2: '0', q1: '1' }
                             })

    assert_equal dfa.states[:q1].edges[:self_referenced][0].value, '0'
    assert_equal dfa.states[:q1].edges[:self_referenced][0].start_state, dfa.states[:q1]
    assert_equal dfa.states[:q1].edges[:self_referenced][0].end_state, dfa.states[:q1]

    assert_equal dfa.states[:q1].edges[:outbound][0].value, '1'
    assert_equal dfa.states[:q1].edges[:outbound][0].start_state, dfa.states[:q1]
    assert_equal dfa.states[:q1].edges[:outbound][0].end_state, dfa.states[:q2]

    assert_equal dfa.states[:q1].edges[:inbound][0].start_state.name, :q2
    assert_equal dfa.states[:q1].edges[:inbound][0].end_state.name, :q1
    assert_equal dfa.states[:q1].edges[:inbound][0].value, '0'
    assert_equal dfa.states[:q1].edges[:inbound][1].start_state.name, :q3
    assert_equal dfa.states[:q1].edges[:inbound][1].end_state.name, :q1
    assert_equal dfa.states[:q1].edges[:inbound][1].value, '1'

    assert_equal dfa.states[:q2].edges[:outbound][0].value, '0'
    assert_equal dfa.states[:q2].edges[:outbound][0].start_state, dfa.states[:q2]
    assert_equal dfa.states[:q2].edges[:outbound][0].end_state, dfa.states[:q1]
    assert_equal dfa.states[:q2].edges[:outbound][1].value, '1'
    assert_equal dfa.states[:q2].edges[:outbound][1].start_state, dfa.states[:q2]
    assert_equal dfa.states[:q2].edges[:outbound][1].end_state, dfa.states[:q3]

    assert_equal dfa.states[:q2].edges[:inbound][0].start_state.name, :q1
    assert_equal dfa.states[:q2].edges[:inbound][0].end_state.name, :q2
    assert_equal dfa.states[:q2].edges[:inbound][0].value, '1'
    assert_equal dfa.states[:q2].edges[:inbound][1].start_state.name, :q3
    assert_equal dfa.states[:q2].edges[:inbound][1].end_state.name, :q2
    assert_equal dfa.states[:q2].edges[:inbound][1].value, '0'

    assert_equal dfa.states[:q3].edges[:outbound][0].value, '0'
    assert_equal dfa.states[:q3].edges[:outbound][0].start_state, dfa.states[:q3]
    assert_equal dfa.states[:q3].edges[:outbound][0].end_state, dfa.states[:q2]
    assert_equal dfa.states[:q3].edges[:outbound][1].value, '1'
    assert_equal dfa.states[:q3].edges[:outbound][1].start_state, dfa.states[:q3]
    assert_equal dfa.states[:q3].edges[:outbound][1].end_state, dfa.states[:q1]

    assert_equal dfa.states[:q3].edges[:inbound][0].start_state.name, :q2
    assert_equal dfa.states[:q3].edges[:inbound][0].end_state.name, :q3
    assert_equal dfa.states[:q3].edges[:inbound][0].value, '1'
  end

  def test_minimaze
    dfa = DFA::Automaton.new(transitions:
                             { q1: { q1: '0', q2: '1' },
                               q2: { q3: '0', q1: '1' },
                               q3: { q2: '0', q3: '1' }
                             })
    dfa.minimaze!
    assert_equal dfa.states.size, 1
    assert_equal dfa.states[:q1].edges[:self_referenced].first.value, '0|1(01*0)*1'
  end

  def test_minimaze_2
    dfa = DFA::Automaton.new(transitions:
                             { a: { b: 'x' },
                               b: { b: 'y', c: 'z' },
                               c: { }
                             }, initial_state: :a, final_state: :c)
    dfa.minimaze!
    assert_equal dfa.states.size, 2
    assert_equal dfa.states[:a].edges[:outbound].first.value, 'xy*z'
  end

  def test_minimaze_divisible_by_5_dfa
    dfa = DFA::Automaton.new(transitions:
                             { q0: { q0: '0', q1: '1' },
                               q1: { q2: '0', q4: '1' },
                               q2: { q3: '0', q0: '1' },
                               q3: { q4: '0', q3: '1' },
                               q4: { q1: '0', q2: '1' }
                             })
    dfa.minimaze!
    assert_equal dfa.states.size, 1
  end
end
