///|
let force_disp_bound_factor = 16.0

///|
let force_zero_factor = 100.0

///|
pub struct AbstractForceModelState {
  mut random : @core.JavaRandom
  mut graph : FGraph?
  mut disp_bound : Double
}

///|
pub fn new_abstract_force_model_state() -> AbstractForceModelState {
  { random: @core.new_java_random_seeded_int(1), graph: None, disp_bound: 0.0, }
}

///|
pub fn abstract_force_model_graph(
  state : AbstractForceModelState,
) -> FGraph raise {
  match state.graph {
    Some(graph) => graph
    None => {
      @core.layout_runtime_raise_unsupported_configuration(
        "force model graph is not initialized",
      )
      new_fgraph()
    }
  }
}

///|
pub fn abstract_force_model_random(
  state : AbstractForceModelState,
) -> @core.JavaRandom {
  state.random
}

///|
pub fn abstract_force_model_disp_bound(
  state : AbstractForceModelState,
) -> Double {
  state.disp_bound
}

///|
pub fn abstract_force_model_initialize(
  state : AbstractForceModelState,
  graph : FGraph,
) -> Unit {
  state.graph = Some(graph)
  state.random = match
    graph.get_internal_random_property(force_internal_random) {
    Some(random_generator) => random_generator
    None => @core.new_java_random_seeded_int(1)
  }
  graph.calc_adjacency()
  let node_count = graph.get_nodes().length().to_double()
  let edge_count = graph.get_edges().length().to_double()
  state.disp_bound = force_max(
    node_count * force_disp_bound_factor + edge_count,
    force_disp_bound_factor * force_disp_bound_factor,
  )
  if !graph.get_property(force_interactive) {
    let position_scale = graph.get_nodes().length().to_double()
    for node in graph.get_nodes() {
      let position = fnode_position(node)
      position.x = state.random.double() * position_scale
      position.y = state.random.double() * position_scale
    }
  }
  let bendpoints = graph.get_bendpoints()
  for edge in graph.get_edges() {
    let count = fedge_get_int_property(edge, force_repulsive_power)
    if count > 0 {
      for _ in 0..<count {
        let bendpoint = new_fbendpoint(edge)
        bendpoints.push(bendpoint)
      }
      fedge_distribute_bendpoints(edge)
    }
  }
}

///|
pub fn abstract_force_model_iteration_done(
  state : AbstractForceModelState,
) -> Unit raise {
  for edge in abstract_force_model_graph(state).get_edges() {
    for label in fedge_labels(edge) {
      flabel_refresh_position(label)
    }
    fedge_distribute_bendpoints(edge)
  }
}

///|
pub fn abstract_force_model_layout(
  state : AbstractForceModelState,
  graph : FGraph,
  monitor : @core.IElkProgressMonitor,
  initialize_hook : () -> Unit raise,
  more_iterations : (Int32) -> Bool raise,
  calc_displacement : (FParticle, FParticle) -> @core.KVector? raise,
  iteration_done_hook : () -> Unit raise,
) -> Unit raise {
  ignore(monitor.begin("Component Layout", 1.0))
  abstract_force_model_initialize(state, graph)
  initialize_hook()
  let mut iteration_count = 0
  while more_iterations(iteration_count) && !monitor.is_canceled() {
    abstract_force_model_iteration_done(state)
    iteration_done_hook()

    // calculate attractive and repulsive forces
    let particles = graph.get_particles()
    for forcee in particles {
      for forcer in particles {
        if !force_particle_equals(forcer, forcee) {
          match calc_displacement(forcer, forcee) {
            Some(displacement) =>
              ignore(fparticle_displacement(forcee).add(displacement))
            None => ()
          }
        }
      }
    }

    // apply calculated displacement
    for particle in particles {
      let displacement = fparticle_displacement(particle)
      ignore(
        displacement.bound(
          -state.disp_bound,
          -state.disp_bound,
          state.disp_bound,
          state.disp_bound,
        ),
      )
      ignore(fparticle_position(particle).add(displacement))
      ignore(displacement.reset())
    }
    iteration_count += 1
  }
  monitor.done()
}

///|
fn force_particle_equals(left : FParticle, right : FParticle) -> Bool {
  match (left, right) {
    (Node(left_node), Node(right_node)) => left_node == right_node
    (Label(left_label), Label(right_label)) => left_label == right_label
    (Bendpoint(left_bendpoint), Bendpoint(right_bendpoint)) =>
      left_bendpoint == right_bendpoint
    _ => false
  }
}

///|
pub fn abstract_force_model_avoid_same_position(
  random_generator : @core.JavaRandom,
  u : FParticle,
  v : FParticle,
) -> Unit {
  let pu = fparticle_position(u)
  let pv = fparticle_position(v)
  while pu.x - pv.x == 0.0 && pu.y - pv.y == 0.0 {
    match (u, v) {
      (Bendpoint(u_bendpoint), Bendpoint(v_bendpoint)) => {
        // Wiggle orthogonal to edge direction
        let u_edge = fbendpoint_edge(u_bendpoint)
        let u_vector = @core.new_kvector_copy(fedge_target_point(u_edge)).sub(
          fedge_source_point(u_edge),
        )
        let orthogonal_u = @core.new_kvector_xy(
          u_vector.x / u_vector.length() * 2.0,
          -u_vector.y / u_vector.length() * 2.0,
        )
        ignore(pu.add(orthogonal_u))
        let v_edge = fbendpoint_edge(v_bendpoint)
        let v_vector = @core.new_kvector_copy(fedge_target_point(v_edge)).sub(
          fedge_source_point(v_edge),
        )
        // ELK compares the two new vectors by reference: never the same
        let length = 2.0
        let orthogonal_v = @core.new_kvector_xy(
          v_vector.x / v_vector.length() * length,
          -(v_vector.y / v_vector.length()) * length,
        )
        ignore(pu.add(orthogonal_v))
      }
      _ => {
        // KVector.wiggle(random, 1)
        pu.x += random_generator.double() * 1.0 - 0.5
        pu.y += random_generator.double() * 1.0 - 0.5
        pv.x += random_generator.double() * 1.0 - 0.5
        pv.y += random_generator.double() * 1.0 - 0.5
      }
    }
  }
}
