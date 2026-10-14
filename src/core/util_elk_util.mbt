///|
pub fn apply_visitors(
  graph : @graph.ElkNode,
  visitors : Array[IGraphElementVisitor],
) -> Unit raise {
  for element in @graph.node_all_descendants_including_self(graph) {
    for visitor in visitors {
      visitor.visit(element)
    }
  }
}

///|
pub fn apply_visitor(
  graph : @graph.ElkNode,
  visitor : IGraphElementVisitor,
) -> Unit raise {
  apply_visitors(graph, [visitor])
}

///|
fn contains_alignment(alignments : Array[String], value : String) -> Bool {
  for alignment in alignments {
    if alignment == value {
      return true
    }
  }
  false
}

///|
pub fn translate(
  parent : @graph.ElkNode,
  new_size : KVector,
  old_size : KVector,
) -> Unit {
  let content_alignment_value = @graph.node_get_string_set_property(
    parent, content_alignment,
  )
  let mut x_translate = 0.0
  let mut y_translate = 0.0
  if new_size.x > old_size.x {
    if contains_alignment(content_alignment_value, "H_CENTER") {
      x_translate = (new_size.x - old_size.x) / 2.0
    } else if contains_alignment(content_alignment_value, "H_RIGHT") {
      x_translate = new_size.x - old_size.x
    }
  }
  if new_size.y > old_size.y {
    if contains_alignment(content_alignment_value, "V_CENTER") {
      y_translate = (new_size.y - old_size.y) / 2.0
    } else if contains_alignment(content_alignment_value, "V_BOTTOM") {
      y_translate = new_size.y - old_size.y
    }
  }
  translate_xy(parent, x_translate, y_translate)
}

///|
pub fn translate_xy(
  parent : @graph.ElkNode,
  x_translate : Double,
  y_translate : Double,
) -> Unit {
  for child in @graph.node_children(parent) {
    @graph.node_set_location(
      child,
      @graph.node_x(child) + x_translate,
      @graph.node_y(child) + y_translate,
    )
  }
}

///|
fn parse_shape_margins(value : String?) -> ElkMargin raise {
  let margins = new_elk_margin()
  if value is Some(text) {
    margins.parse(text)
  }
  margins
}

///|
fn update_bounds(
  min_x : Ref[Double],
  min_y : Ref[Double],
  max_x : Ref[Double],
  max_y : Ref[Double],
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  margins : ElkMargin,
) -> Unit {
  let left = x - margins.left
  let top = y - margins.top
  let right = x + width + margins.right
  let bottom = y + height + margins.bottom
  if left < min_x.val {
    min_x.val = left
  }
  if top < min_y.val {
    min_y.val = top
  }
  if right > max_x.val {
    max_x.val = right
  }
  if bottom > max_y.val {
    max_y.val = bottom
  }
}

///|
pub fn compute_child_area_dimensions(node : @graph.ElkNode) -> Unit raise {
  let min_x : Ref[Double] = Ref(@double.infinity)
  let min_y : Ref[Double] = Ref(@double.infinity)
  let max_x : Ref[Double] = Ref(0.0)
  let max_y : Ref[Double] = Ref(0.0)

  for label in @graph.node_labels(node) {
    update_bounds(
      min_x,
      min_y,
      max_x,
      max_y,
      @graph.label_x(label),
      @graph.label_y(label),
      @graph.label_width(label),
      @graph.label_height(label),
      parse_shape_margins(
        @graph.label_layout_option_string_value(
          label, "org.eclipse.elk.margins",
        ),
      ),
    )
  }

  for child in @graph.node_children(node) {
    update_bounds(
      min_x,
      min_y,
      max_x,
      max_y,
      @graph.node_x(child),
      @graph.node_y(child),
      @graph.node_width(child),
      @graph.node_height(child),
      parse_shape_margins(
        @graph.node_layout_option_string_value(child, "org.eclipse.elk.margins"),
      ),
    )
  }

  for edge in @graph.node_contained_edges(node) {
    for label in @graph.edge_labels(edge) {
      update_bounds(
        min_x,
        min_y,
        max_x,
        max_y,
        @graph.label_x(label),
        @graph.label_y(label),
        @graph.label_width(label),
        @graph.label_height(label),
        parse_shape_margins(
          @graph.label_layout_option_string_value(
            label, "org.eclipse.elk.margins",
          ),
        ),
      )
    }
  }

  for edge in @graph.node_contained_edges(node) {
    for section in @graph.edge_sections(edge) {
      let sx = @graph.edge_section_start_x(section)
      let sy = @graph.edge_section_start_y(section)
      let ex = @graph.edge_section_end_x(section)
      let ey = @graph.edge_section_end_y(section)

      if sx < min_x.val {
        min_x.val = sx
      }
      if ex < min_x.val {
        min_x.val = ex
      }
      if sy < min_y.val {
        min_y.val = sy
      }
      if ey < min_y.val {
        min_y.val = ey
      }

      if sx > max_x.val {
        max_x.val = sx
      }
      if ex > max_x.val {
        max_x.val = ex
      }
      if sy > max_y.val {
        max_y.val = sy
      }
      if ey > max_y.val {
        max_y.val = ey
      }
    }
  }

  @graph.node_set_double_property(node, child_area_width, max_x.val - min_x.val)
  @graph.node_set_double_property(
    node,
    child_area_height,
    max_y.val - min_y.val,
  )
}

///|
/// The side of `port` judged by its position on its node, as
/// `ElkUtil.calcPortSide` does; `"UNDEFINED"` for a node without size.
pub fn calc_port_side(port : @graph.ElkPort, direction : String) -> String {
  let node = match @graph.port_parent(port) {
    Some(node) => node
    None => abort("port must have a parent node to calculate the port side")
  }
  let node_width = @graph.node_width(node)
  let node_height = @graph.node_height(node)
  if node_width <= 0.0 && node_height <= 0.0 {
    return "UNDEFINED"
  }
  let xpos = @graph.port_x(port)
  let ypos = @graph.port_y(port)
  match direction {
    "LEFT" | "RIGHT" =>
      if xpos < 0.0 {
        return "WEST"
      } else if xpos + @graph.port_width(port) > node_width {
        return "EAST"
      }
    "UP" | "DOWN" =>
      if ypos < 0.0 {
        return "NORTH"
      } else if ypos + @graph.port_height(port) > node_height {
        return "SOUTH"
      }
    _ => ()
  }
  let width_percent = (xpos + @graph.port_width(port) / 2.0) / node_width
  let height_percent = (ypos + @graph.port_height(port) / 2.0) / node_height
  if width_percent + height_percent <= 1.0 &&
    width_percent - height_percent <= 0.0 {
    "WEST"
  } else if width_percent + height_percent >= 1.0 &&
    width_percent - height_percent >= 0.0 {
    "EAST"
  } else if height_percent < 0.5 {
    "NORTH"
  } else {
    "SOUTH"
  }
}

///|
/// Resizes `node` as `ElkUtil.resizeNode(node, newWidth, newHeight, false,
/// moveLabels)` does: the size is at least the node's effective minimum size,
/// labels on the right or bottom move with the border when `move_labels` is
/// set, and the node's size constraints become fixed, so that a layout of the
/// parent keeps the size. Ports move with the border when `move_ports` is
/// set. Returns the width and height ratios.
pub fn resize_node(
  node : @graph.ElkNode,
  new_width : Double,
  new_height : Double,
  move_ports~ : Bool,
  move_labels~ : Bool,
) -> KVector raise {
  let old_size = new_kvector_xy(
    @graph.node_width(node),
    @graph.node_height(node),
  )
  let new_size = box_layout_provider_effective_min_size_constraint_for(node)
  if new_width > new_size.x {
    new_size.x = new_width
  }
  if new_height > new_size.y {
    new_size.y = new_height
  }
  let width_ratio = new_size.x / old_size.x
  let height_ratio = new_size.y / old_size.y
  let width_diff = new_size.x - old_size.x
  let height_diff = new_size.y - old_size.y
  if move_ports {
    let direction_value = match @graph.node_parent(node) {
      Some(parent) => @graph.node_get_string_property(parent, direction)
      None => @graph.node_get_string_property(node, direction)
    }
    let fixed_ports = @graph.node_get_string_property(node, port_constraints) ==
      "FIXED_POS"
    for port in @graph.node_ports(node) {
      let mut side = @graph.port_layout_option_string_value_by_option_id(
        port,
        port_side.get_property_id(),
      ).unwrap_or("UNDEFINED")
      if side == "UNDEFINED" {
        side = calc_port_side(port, direction_value)
        @graph.port_set_layout_option_string_by_id(
          port,
          port_side.get_id(),
          side,
        )
      }
      let x = @graph.port_x(port)
      let y = @graph.port_y(port)
      match side {
        "NORTH" =>
          if !fixed_ports {
            @graph.port_set_location(port, x * width_ratio, y)
          }
        "EAST" =>
          @graph.port_set_location(
            port,
            x + width_diff,
            if fixed_ports {
              y
            } else {
              y * height_ratio
            },
          )
        "SOUTH" =>
          @graph.port_set_location(
            port,
            if fixed_ports {
              x
            } else {
              x * width_ratio
            },
            y + height_diff,
          )
        "WEST" =>
          if !fixed_ports {
            @graph.port_set_location(port, x, y * height_ratio)
          }
        _ => ()
      }
    }
  }
  // resize the node after the ports were placed: calc_port_side needs the
  // old size
  @graph.node_set_dimensions(node, new_size.x, new_size.y)
  if move_labels {
    for label in @graph.node_labels(node) {
      let midx = @graph.label_x(label) + @graph.label_width(label) / 2.0
      let midy = @graph.label_y(label) + @graph.label_height(label) / 2.0
      let width_percent = midx / old_size.x
      let height_percent = midy / old_size.y
      if width_percent + height_percent >= 1.0 {
        if width_percent - height_percent > 0.0 && midy >= 0.0 {
          // label is on the right
          @graph.label_set_location(
            label,
            @graph.label_x(label) + width_diff,
            @graph.label_y(label) + height_diff * height_percent,
          )
        } else if width_percent - height_percent < 0.0 && midx >= 0.0 {
          // label is on the bottom
          @graph.label_set_location(
            label,
            @graph.label_x(label) + width_diff * width_percent,
            @graph.label_y(label) + height_diff,
          )
        }
      }
    }
  }
  @graph.node_set_string_set_property(node, node_size_constraints, [])
  new_kvector_xy(width_ratio, height_ratio)
}
