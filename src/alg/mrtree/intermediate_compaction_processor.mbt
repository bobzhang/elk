///|
/// A `TreeSet<TNode>` ordered by the nodes' projection on a direction: nodes
/// with the same projection are the same element for the set.
priv struct MrtreeProjectionSet {
  nodes : Array[MrtreeNode]
  direction_vector : @core.KVector
}

///|
fn MrtreeProjectionSet::key(
  self : MrtreeProjectionSet,
  node : MrtreeNode,
) -> Double {
  // TreeUtil.getDirectionVector(d).dotProduct(x.getPosition().clone())
  self.direction_vector.dot_product(mrtree_node_position(node))
}

///|
/// The number of elements whose key is below the node's (`headSet(n).size()`).
fn MrtreeProjectionSet::head_size(
  self : MrtreeProjectionSet,
  node : MrtreeNode,
) -> Int32 {
  let key = self.key(node)
  let mut count = 0
  while count < self.nodes.length() &&
        java_double_compare(self.key(self.nodes[count]), key) < 0 {
    count += 1
  }
  count
}

///|
fn MrtreeProjectionSet::add(
  self : MrtreeProjectionSet,
  node : MrtreeNode,
) -> Unit {
  let index = self.head_size(node)
  if index < self.nodes.length() &&
    java_double_compare(self.key(self.nodes[index]), self.key(node)) == 0 {
    return
  }
  self.nodes.insert(index, node)
}

///|
fn MrtreeProjectionSet::remove(
  self : MrtreeProjectionSet,
  node : MrtreeNode,
) -> Unit {
  let index = self.head_size(node)
  if index < self.nodes.length() &&
    java_double_compare(self.key(self.nodes[index]), self.key(node)) == 0 {
    ignore(self.nodes.remove(index))
  }
}

///|
/// `Double.compare`.
fn java_double_compare(a : Double, b : Double) -> Int32 {
  if a < b {
    -1
  } else if a > b {
    1
  } else {
    let a_bits = if a.is_nan() {
      0x7ff8000000000000L
    } else {
      a.reinterpret_as_int64()
    }
    let b_bits = if b.is_nan() {
      0x7ff8000000000000L
    } else {
      b.reinterpret_as_int64()
    }
    a_bits.compare(b_bits)
  }
}

///|
fn mrtree_compaction_get_lowest_dependent_node(
  node : MrtreeNode,
  direction_value : String,
) -> MrtreeNode? {
  let constraints = mrtree_node_compact_constraints(node)
  if constraints.is_empty() {
    return None
  }
  if constraints.length() == 1 {
    return Some(constraints[0])
  }

  let mut lowest_constraint = constraints[0]
  for constraint in constraints {
    let constraint_position = mrtree_node_position(constraint)
    let lowest_position = mrtree_node_position(lowest_constraint)
    let constraint_size = mrtree_node_size(constraint)
    let lowest_size = mrtree_node_size(lowest_constraint)
    if direction_value == "LEFT" {
      if constraint_position.x < lowest_position.x {
        lowest_constraint = constraint
      }
    } else if direction_value == "RIGHT" {
      if constraint_position.x + constraint_size.x >
        lowest_position.x + lowest_size.x {
        lowest_constraint = constraint
      }
    } else if direction_value == "UP" {
      if constraint_position.y < lowest_position.y {
        lowest_constraint = constraint
      }
    } else if constraint_position.y + constraint_size.y >
      lowest_position.y + lowest_size.y {
      lowest_constraint = constraint
    }
  }
  Some(lowest_constraint)
}

///|
fn mrtree_compaction_set_up_levels(
  graph : MrtreeGraph,
  direction_value : String,
) -> Array[@core.KVector] {
  let levels : Array[@core.KVector] = []
  for node in mrtree_graph_nodes(graph) {
    while mrtree_node_tree_level(node) > levels.length() - 1 {
      levels.push(@core.new_kvector_xy(@double.max_value, -@double.max_value))
    }
    let current_level = mrtree_node_tree_level(node)
    let level = levels[current_level]
    let position = mrtree_node_position(node)
    let size = mrtree_node_size(node)
    if mrtree_tree_util_direction_is_horizontal(direction_value) {
      if position.x < level.x {
        level.x = position.x
      }
      if position.x + size.x > level.y {
        level.y = position.x + size.x
      }
    } else {
      if position.y < level.x {
        level.x = position.y
      }
      if position.y + size.y > level.y {
        level.y = position.y + size.y
      }
    }
  }
  levels
}

///|
fn mrtree_compaction_compute_node_constraints(
  graph : MrtreeGraph,
  node_node_spacing : Double,
) -> Unit {
  let direction_value = mrtree_graph_direction(graph)
  let right_direction = if mrtree_tree_util_direction_is_horizontal(
      direction_value,
    ) {
    "DOWN"
  } else {
    "RIGHT"
  }
  let right_direction_vector = mrtree_tree_util_get_direction_vector(
    right_direction,
  )
  let direction_vector = mrtree_tree_util_get_direction_vector(direction_value)

  let actual_nodes = []
  for node in mrtree_graph_nodes(graph) {
    if !mrtree_node_label(node).contains("SUPER_ROOT") {
      actual_nodes.push(node)
    }
    mrtree_node_set_compact_constraints(node, [])
  }

  let points : Array[@core.Triple[MrtreeNode, @core.KVector, Bool]] = []
  for node in actual_nodes {
    let start = @core.new_kvector_copy(mrtree_node_position(node))
    ignore(start.sub_xy(node_node_spacing, node_node_spacing))
    points.push(@core.triple_of(node, start, true))
  }
  for node in actual_nodes {
    let end_point = @core.new_kvector_copy(mrtree_node_position(node))
    let size = mrtree_node_size(node)
    ignore(
      end_point.add_xy(size.x + node_node_spacing, size.y + node_node_spacing),
    )
    points.push(@core.triple_of(node, end_point, false))
  }

  let points_len = points.length()
  for i in 1..<points_len {
    let current = points[i]
    let current_projection = current
      .get_second()
      .dot_product(right_direction_vector)
    let mut j = i
    while j > 0 &&
          current_projection <
          points[j - 1].get_second().dot_product(right_direction_vector) {
      points[j] = points[j - 1]
      j -= 1
    }
    points[j] = current
  }

  let set : MrtreeProjectionSet = { nodes: [], direction_vector, }
  let candidates : Map[MrtreeNode, MrtreeNode] = Map([])

  for point in points {
    let r = point.get_first()
    if point.get_third() {
      set.add(r)
      let head = set.head_size(r)
      if head > 0 {
        candidates[r] = set.nodes[head - 1]
      }
      if set.nodes.length() - head > 1 {
        // getRightElement: the second element of the tail set
        candidates[set.nodes[head + 1]] = r
      }
    } else {
      // This deviates a bit from the proposed pseudo code but we need to
      // check if right and left even exist
      let head = set.head_size(r)
      if head > 0 {
        let left_node = set.nodes[head - 1]
        if candidates.get(r) is Some(candidate) && candidate == left_node {
          mrtree_node_add_compact_constraint(r, left_node)
        }
      }
      if set.nodes.length() - head > 1 {
        let right_node = set.nodes[head + 1]
        if candidates.get(right_node) is Some(candidate) && candidate == r {
          mrtree_node_add_compact_constraint(right_node, r)
        }
      }
      set.remove(r)
    }
  }
}

///|
fn mrtree_compaction_sort_nodes(
  nodes : Array[MrtreeNode],
  direction_value : String,
) -> Unit {
  let direction_vector = mrtree_tree_util_get_direction_vector(direction_value)
  let length = nodes.length()
  for i in 1..<length {
    let current = nodes[i]
    let current_projection = direction_vector.dot_product(
      @core.new_kvector_xy(
        mrtree_node_position(current).x,
        mrtree_node_position(current).y,
      ),
    )
    let mut j = i
    while j > 0 &&
          current_projection <
          direction_vector.dot_product(
            @core.new_kvector_xy(
              mrtree_node_position(nodes[j - 1]).x,
              mrtree_node_position(nodes[j - 1]).y,
            ),
          ) {
      nodes[j] = nodes[j - 1]
      j -= 1
    }
    nodes[j] = current
  }
}

///|
fn mrtree_compaction_processor_process(
  graph : MrtreeGraph,
  progress_monitor : @core.IElkProgressMonitor?,
) -> Unit raise {
  match progress_monitor {
    Some(monitor) => ignore(monitor.begin("Process compaction", 1.0))
    None => ()
  }

  if !mrtree_graph_compaction(graph) {
    return
  }

  let direction_value = mrtree_graph_direction(graph)
  let node_node_spacing = mrtree_graph_spacing_node_node(graph)

  let levels = mrtree_compaction_set_up_levels(graph, direction_value)
  mrtree_compaction_compute_node_constraints(
    graph,
    node_node_spacing / 2.0 / 2.0,
  )

  // ELK sorts the graph's node list itself
  let nodes = mrtree_graph_nodes(graph)
  mrtree_compaction_sort_nodes(nodes, direction_value)

  for node in nodes {
    if !mrtree_node_root(node) {
      let dependent_node = mrtree_compaction_get_lowest_dependent_node(
        node, direction_value,
      )
      let parent_node = mrtree_tree_util_get_lowest_parent(node, graph)
      let mut new_pos = 0.0
      let mut new_pos_size = 0.0

      match dependent_node {
        Some(dependent) => {
          let dependent_position = mrtree_node_position(dependent)
          match parent_node {
            Some(parent) => {
              let parent_position = mrtree_node_position(parent)
              let parent_size = mrtree_node_size(parent)
              let node_size = mrtree_node_size(node)
              let dependent_size = mrtree_node_size(dependent)
              if direction_value == "LEFT" {
                new_pos = dependent_position.x - node_node_spacing - node_size.x
                if parent_position.x - node_node_spacing - node_size.x < new_pos {
                  new_pos = parent_position.x - node_node_spacing - node_size.x
                }
                new_pos_size = new_pos + node_size.x
              } else if direction_value == "RIGHT" {
                new_pos = dependent_position.x +
                  dependent_size.x +
                  node_node_spacing
                if parent_position.x + node_node_spacing > new_pos {
                  new_pos = parent_position.x +
                    parent_size.x +
                    node_node_spacing
                }
                new_pos_size = new_pos + node_size.x
              } else if direction_value == "UP" {
                new_pos = dependent_position.y - node_node_spacing - node_size.y
                if parent_position.y - node_node_spacing - node_size.y < new_pos {
                  new_pos = parent_position.y - node_node_spacing - node_size.y
                }
                new_pos_size = new_pos + node_size.y
              } else {
                new_pos = dependent_position.y +
                  dependent_size.y +
                  node_node_spacing
                if parent_position.y + node_node_spacing > new_pos {
                  new_pos = parent_position.y +
                    parent_size.y +
                    node_node_spacing
                }
                new_pos_size = new_pos + node_size.y
              }
            }
            None =>
              @core.layout_runtime_raise_unsupported_configuration(
                "java.lang.NullPointerException",
              )
          }
        }
        None =>
          match parent_node {
            Some(parent) => {
              let parent_position = mrtree_node_position(parent)
              let parent_size = mrtree_node_size(parent)
              let node_size = mrtree_node_size(node)
              if direction_value == "LEFT" {
                new_pos = parent_position.x - node_node_spacing - node_size.x
                new_pos_size = new_pos + node_size.x
              } else if direction_value == "RIGHT" {
                new_pos = parent_position.x + parent_size.x + node_node_spacing
                new_pos_size = new_pos + node_size.x
              } else if direction_value == "UP" {
                new_pos = parent_position.y - node_node_spacing - node_size.y
                new_pos_size = new_pos + node_size.y
              } else {
                new_pos = parent_position.y + parent_size.y + node_node_spacing
                new_pos_size = new_pos + node_size.y
              }
            }
            None => ()
          }
      }

      if mrtree_graph_edge_routing_mode(graph) is AVOID_OVERLAP {
        let mut level_index : Int32? = None
        for i in 0..<levels.length() {
          let level = levels[i]
          if level.x <= new_pos && level.y >= new_pos_size {
            level_index = Some(i)
            break
          }
        }

        if level_index != None {
          // The Node ended up within a level
          if mrtree_tree_util_direction_is_horizontal(direction_value) {
            mrtree_node_position(node).x = new_pos
          } else {
            mrtree_node_position(node).y = new_pos
          }
        } else {
          if direction_value == "LEFT" || direction_value == "UP" {
            // Skip the first level as it only contains the SUPER_ROOT here
            for i in 1..<levels.length() {
              if levels[i].x <= new_pos {
                level_index = Some(i)
                break
              }
            }
          } else {
            for i in 1..<levels.length() {
              if levels[i].x >= new_pos {
                level_index = Some(i)
                break
              }
            }
          }
          // Force n into the found level
          if level_index is Some(index) {
            if mrtree_tree_util_direction_is_horizontal(direction_value) {
              mrtree_node_position(node).x = levels[index].x
            } else {
              mrtree_node_position(node).y = levels[index].x
            }
          }
        }

        match level_index {
          Some(found) => {
            // levels.indexOf(level): the first level equal to the found one
            let mut index = 0
            while levels[index].x != levels[found].x ||
                  levels[index].y != levels[found].y {
              index += 1
            }
            if index > 0 && index != mrtree_node_tree_level(node) {
              mrtree_node_set_compact_level_ascension(node, true)
              mrtree_node_set_tree_level(node, index)
            }
          }
          None => ()
        }
      } else if mrtree_tree_util_direction_is_horizontal(direction_value) {
        mrtree_node_position(node).x = new_pos
      } else {
        mrtree_node_position(node).y = new_pos
      }
    }
  }

  match progress_monitor {
    Some(monitor) => monitor.done()
    None => ()
  }
}

///|
pub fn new_mrtree_compaction_processor_layout_processor() -> @core.TypedLayoutProcessor[
  MrtreeGraph,
] {
  @core.new_layout_processor(mrtree_compaction_processor_process)
}
