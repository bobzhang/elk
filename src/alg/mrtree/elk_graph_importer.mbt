///|
pub struct MrtreeElkGraphImporter {
  marker : Int32
}

///|
pub fn new_mrtree_elk_graph_importer() -> MrtreeElkGraphImporter {
  { marker: 0, }
}

///|
fn mrtree_target_node_from_edge(edge : @graph.ElkEdge) -> @graph.ElkNode? {
  if @graph.edge_targets(edge).is_empty() {
    return None
  }
  match @graph.edge_targets(edge)[0] {
    NodeShape(node) => Some(node)
    PortShape(port) => @graph.port_parent(port)
  }
}

///|
fn mrtree_all_outgoing_edges(node : @graph.ElkNode) -> Array[@graph.ElkEdge] {
  let outgoing = []
  let seen : Map[@graph.ElkEdge, Bool] = Map([])

  for edge in @graph.node_outgoing_edges(node) {
    if !seen.contains(edge) {
      seen[edge] = true
      outgoing.push(edge)
    }
  }

  for port in @graph.node_ports(node) {
    for edge in @graph.port_outgoing_edges(port) {
      if !seen.contains(edge) {
        seen[edge] = true
        outgoing.push(edge)
      }
    }
  }

  outgoing
}

///|
fn mrtree_edge_is_hierarchical(
  parent_node : @graph.ElkNode,
  target_node : @graph.ElkNode,
) -> Bool {
  if @graph.node_parent(target_node) is Some(target_parent) {
    target_parent != parent_node
  } else {
    true
  }
}

///|
fn mrtree_first_or_create_edge_section(
  edge : @graph.ElkEdge,
) -> @graph.ElkEdgeSection {
  let sections = @graph.edge_sections(edge)
  if sections.is_empty() {
    @graph.create_edge_section(edge)
  } else {
    sections[0]
  }
}

///|
/// `ElkUtil.applyVectorChain` on the edge's first section: the first point
/// is the start, the last the end, and the ones between are the bend points.
fn mrtree_apply_vector_chain_to_edge(
  vector_chain : @core.KVectorChain,
  edge : @graph.ElkEdge,
) -> Unit raise {
  if vector_chain.size() < 2 {
    @core.layout_runtime_raise_unsupported_configuration(
      "java.lang.IllegalArgumentException: The vector chain must contain at least a source and a target point.",
    )
  }
  let first_section = mrtree_first_or_create_edge_section(edge)
  let first_point = vector_chain.get(0)
  @graph.edge_section_set_start(first_section, first_point.x, first_point.y)
  @graph.edge_section_clear_bend_points(first_section)
  for i in 1..<(vector_chain.size() - 1) {
    let point = vector_chain.get(i)
    @graph.edge_section_add_bend_point(
      first_section,
      @graph.new_elk_bend_point(x=point.x, y=point.y),
    )
  }
  let last_point = vector_chain.get(vector_chain.size() - 1)
  @graph.edge_section_set_end(first_section, last_point.x, last_point.y)
}

///|
fn mrtree_transform_nodes(
  parent_node : @graph.ElkNode,
  graph : MrtreeGraph,
  elem_map : Map[@graph.ElkNode, MrtreeNode],
) -> Unit {
  let mut index = 0
  for elk_node in @graph.node_children(parent_node) {
    let label = if @graph.node_labels(elk_node).is_empty() {
      ""
    } else {
      @graph.label_text(@graph.node_labels(elk_node)[0])
    }
    let node = new_mrtree_node(index, graph, label~)
    mrtree_node_copy_properties_from_elk(node, elk_node)
    let position = mrtree_node_position(node)
    let size = mrtree_node_size(node)
    position.y = @graph.node_y(elk_node) + @graph.node_height(elk_node) / 2.0
    size.x = if @graph.node_width(elk_node) > 1.0 {
      @graph.node_width(elk_node)
    } else {
      1.0
    }
    position.x = @graph.node_x(elk_node) + @graph.node_width(elk_node) / 2.0
    size.y = if @graph.node_height(elk_node) > 1.0 {
      @graph.node_height(elk_node)
    } else {
      1.0
    }
    elem_map[elk_node] = node
    index += 1
  }
}

///|
fn mrtree_transform_edges(
  parent_node : @graph.ElkNode,
  elem_map : Map[@graph.ElkNode, MrtreeNode],
) -> Unit {
  for source_elk in @graph.node_children(parent_node) {
    let source = match elem_map.get(source_elk) {
      Some(node) => node
      None => continue
    }
    for elk_edge in mrtree_all_outgoing_edges(source_elk) {
      let target_elk = match mrtree_target_node_from_edge(elk_edge) {
        Some(node) => node
        None => continue
      }
      if source_elk == target_elk {
        continue
      }
      if mrtree_edge_is_hierarchical(parent_node, target_elk) {
        continue
      }
      let target = match elem_map.get(target_elk) {
        Some(node) => node
        None => continue
      }
      let edge = new_mrtree_edge(source, target)
      mrtree_edge_set_origin(edge, Some(elk_edge))
    }
  }
}

///|
pub fn MrtreeElkGraphImporter::import_graph(
  self : MrtreeElkGraphImporter,
  elk_graph : @graph.ElkNode,
) -> MrtreeGraph raise {
  ignore(self)
  let graph = new_mrtree_graph()
  mrtree_graph_copy_properties_from_elk(graph, elk_graph)
  let elem_map = Map([])
  mrtree_transform_nodes(elk_graph, graph, elem_map)
  mrtree_transform_edges(elk_graph, elem_map)
  graph
}

///|
/// `ElkGraphImporter.applyLayout` of ELK 0.9.1. The node positions are used
/// as the nodes' locations as they are, while the graph's size is computed
/// as if they were the nodes' centers.
pub fn MrtreeElkGraphImporter::apply_layout(
  self : MrtreeElkGraphImporter,
  graph : MrtreeGraph,
) -> Unit raise {
  ignore(self)
  let elk_graph = match mrtree_graph_origin(graph) {
    Some(origin) => origin
    None => return
  }
  let mut min_x = 2147483647.0
  let mut min_y = 2147483647.0
  let mut max_x = -2147483648.0
  let mut max_y = -2147483648.0
  for node in mrtree_graph_nodes(graph) {
    let position = mrtree_node_position(node)
    let size = mrtree_node_size(node)
    min_x = java_min(min_x, position.x - size.x / 2.0)
    min_y = java_min(min_y, position.y - size.y / 2.0)
    max_x = java_max(max_x, position.x + size.x / 2.0)
    max_y = java_max(max_y, position.y + size.y / 2.0)
  }

  let padding_value = mrtree_parse_padding(
    @graph.node_get_string_property(elk_graph, mrtree_padding),
  )

  for node in mrtree_graph_nodes(graph) {
    match mrtree_node_origin(node) {
      Some(elk_node) => {
        let position = mrtree_node_position(node)
        @graph.node_set_location(elk_node, position.x, position.y)
      }
      None => ()
    }
  }

  for edge in mrtree_graph_edges(graph) {
    if mrtree_edge_origin(edge) is Some(elk_edge) {
      mrtree_apply_vector_chain_to_edge(mrtree_edge_bend_points(edge), elk_edge)
    }
  }

  let width = max_x - min_x + padding_value.get_horizontal()
  let height = max_y - min_y + padding_value.get_vertical()
  if !@graph.node_get_bool_property(elk_graph, @core.node_size_fixed_graph_size) {
    ignore(
      @core.resize_node(
        elk_graph,
        width,
        height,
        move_ports=false,
        move_labels=false,
      ),
    )
  }
  @graph.node_set_double_property(
    elk_graph,
    @core.child_area_width,
    width - padding_value.get_horizontal(),
  )
  @graph.node_set_double_property(
    elk_graph,
    @core.child_area_height,
    height - padding_value.get_vertical(),
  )
}

///|
/// Java's `Math.min` for doubles.
fn java_min(a : Double, b : Double) -> Double {
  if a.is_nan() {
    a
  } else if a == 0.0 && b == 0.0 {
    if 1.0 / a < 0.0 {
      a
    } else {
      b
    }
  } else if a <= b {
    a
  } else {
    b
  }
}

///|
/// Java's `Math.max` for doubles.
fn java_max(a : Double, b : Double) -> Double {
  if a.is_nan() {
    a
  } else if a == 0.0 && b == 0.0 {
    if 1.0 / a > 0.0 {
      a
    } else {
      b
    }
  } else if a >= b {
    a
  } else {
    b
  }
}

///|
pub fn new_mrtree_elk_graph_as_igraph_importer() -> MrtreeIGraphImporter[
  @graph.ElkNode,
] {
  let importer = new_mrtree_elk_graph_importer()
  new_mrtree_igraph_importer(
    fn(graph : @graph.ElkNode) raise { importer.import_graph(graph) },
    graph => importer.apply_layout(graph),
  )
}
