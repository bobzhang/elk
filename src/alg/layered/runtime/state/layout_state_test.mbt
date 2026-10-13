///|
test "layout state resets deterministic random sequence" {
  let state = new_layered_layout_state()
  state.initialize_random(42)
  let first = state.random(42).next_int(1000)
  assert_eq(state.first_random_boolean(), Some(true))

  state.clear()
  assert_eq(state.first_random_boolean(), None)

  state.initialize_random(42)
  assert_eq(state.random(42).next_int(1000), first)
}

///|
test "layout state: every configured graph draws from its own sequence" {
  let state = @state.new_layered_layout_state()
  state.initialize_graph_random(1, 42)
  state.initialize_graph_random(2, 42)
  let first = state.graph_random(1, 42).next_int(1000)
  // Graph 2 has not drawn anything yet, whatever graph 1 did.
  assert_eq(state.graph_random(2, 42).next_int(1000), first)
  assert_not_eq(state.graph_random(1, 42).next_int(1000), first)
  // A graph that was never configured shares the generator set up last.
  state.initialize_graph_random(3, 42)
  assert_eq(state.graph_random(4, 42).next_int(1000), first)
  assert_not_eq(state.graph_random(3, 42).next_int(1000), first)
}
