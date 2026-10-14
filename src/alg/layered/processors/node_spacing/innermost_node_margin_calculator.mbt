///|
fn innermost_node_margin_calculator_max(a : Double, b : Double) -> Double {
  if a > b {
    a
  } else {
    b
  }
}

///|
/// The margin of a node around its labels, its ports and their labels,
/// with the arithmetic of ELK's `NodeMarginCalculator`: a bounding box in
/// the coordinates of the graph, grown by uniting it with each element,
/// from which the margins are then taken. The size of that box is a
/// difference of its edges, so a margin can come out a last bit away from
/// how far the element behind it sticks out.
fn innermost_node_margin_calculator_process_node(node : @runtime.LNode) -> Unit {
  let node_position = node.get_position()
  let node_size = node.get_size()
  let bounding_box = @core.new_elk_rectangle_xywh(
    node_position.x,
    node_position.y,
    node_size.x,
    node_size.y,
  )
  let element_box = @core.new_elk_rectangle()

  for label in node.get_labels() {
    let label_pos = label.get_position()
    let label_size = label.get_size()
    element_box.set_rect(
      label_pos.x + node_position.x,
      label_pos.y + node_position.y,
      label_size.x,
      label_size.y,
    )
    bounding_box.union(element_box)
  }

  for port in node.get_ports() {
    let port_pos = port.get_position()
    let port_size = port.get_size()
    let port_x = port_pos.x + node_position.x
    let port_y = port_pos.y + node_position.y
    element_box.set_rect(port_x, port_y, port_size.x, port_size.y)
    bounding_box.union(element_box)

    for label in port.get_labels() {
      let label_pos = label.get_position()
      let label_size = label.get_size()
      element_box.set_rect(
        label_pos.x + port_x,
        label_pos.y + port_y,
        label_size.x,
        label_size.y,
      )
      bounding_box.union(element_box)
    }
  }

  let margin = node.get_margin()
  margin.top = innermost_node_margin_calculator_max(
    0.0,
    node_position.y - bounding_box.y,
  )
  margin.bottom = innermost_node_margin_calculator_max(
    0.0,
    bounding_box.y + bounding_box.height - (node_position.y + node_size.y),
  )
  margin.left = innermost_node_margin_calculator_max(
    0.0,
    node_position.x - bounding_box.x,
  )
  margin.right = innermost_node_margin_calculator_max(
    0.0,
    bounding_box.x + bounding_box.width - (node_position.x + node_size.x),
  )
}

///|
fn innermost_node_margin_calculator_process(
  layered_graph : @runtime.LGraph,
  progress_monitor : @core.IElkProgressMonitor?,
) -> Unit raise {
  let monitor = match progress_monitor {
    Some(value) => value
    None => @core.new_null_elk_progress_monitor()
  }
  ignore(monitor.begin("Node margin calculation", 1.0))

  for node in layered_graph.get_layerless_nodes() {
    innermost_node_margin_calculator_process_node(node)
  }
  for layer in layered_graph.get_layers() {
    for node in layer.get_nodes() {
      innermost_node_margin_calculator_process_node(node)
    }
  }

  monitor.done()
}

///|
pub fn new_innermost_node_margin_calculator_layout_processor() -> @core.TypedLayoutProcessor[
  @runtime.LGraph,
] {
  @core.new_layout_processor(innermost_node_margin_calculator_process)
}
