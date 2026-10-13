// Graphs that mermaid 12.2.0 hands to ELK for small flowcharts, with the
// layout elkjs 0.9.3 computes for them. Expectations list every node as
// "id: x, y widthxheight" and every edge as its route.

///|
fn mermaid_parity_number(value : Double) -> String {
  if value == 0.0 {
    "0"
  } else {
    value.to_string()
  }
}

///|
fn mermaid_parity_field(object : Json, key : String) -> Double {
  match object {
    Object(fields) =>
      match fields.get(key) {
        Some(Number(value, ..)) => value
        _ => 0.0
      }
    _ => 0.0
  }
}

///|
fn mermaid_parity_items(object : Json, key : String) -> Array[Json] {
  match object {
    Object(fields) =>
      match fields.get(key) {
        Some(Array(items)) => items
        _ => []
      }
    _ => []
  }
}

///|
fn mermaid_parity_text(object : Json, key : String) -> String {
  match object {
    Object(fields) =>
      match fields.get(key) {
        Some(String(value)) => value
        _ => ""
      }
    _ => ""
  }
}

///|
fn mermaid_parity_nodes(
  node : Json,
  depth : Int32,
  out : Array[String],
) -> Unit {
  let n = mermaid_parity_number
  let f = mermaid_parity_field
  if depth == 0 {
    out.push("root \{n(f(node, "width"))}x\{n(f(node, "height"))}")
  } else {
    let indent = "  ".repeat(depth - 1)
    let id = mermaid_parity_text(node, "id")
    out.push(
      "\{indent}\{id}: \{n(f(node, "x"))}, \{n(f(node, "y"))} \{n(f(node, "width"))}x\{n(f(node, "height"))}",
    )
  }
  for child in mermaid_parity_items(node, "children") {
    mermaid_parity_nodes(child, depth + 1, out)
  }
}

///|
fn mermaid_parity_edges(node : Json, out : Array[String]) -> Unit {
  let n = mermaid_parity_number
  let f = mermaid_parity_field
  for edge in mermaid_parity_items(node, "edges") {
    let id = mermaid_parity_text(edge, "id")
    for section in mermaid_parity_items(edge, "sections") {
      guard section is Object(fields) else { continue }
      let points = []
      if fields.get("startPoint") is Some(point) {
        points.push(point)
      }
      for point in mermaid_parity_items(section, "bendPoints") {
        points.push(point)
      }
      if fields.get("endPoint") is Some(point) {
        points.push(point)
      }
      let route = points.map(p => "\{n(f(p, "x"))},\{n(f(p, "y"))}").join(" ")
      out.push("\{id}: \{route}")
    }
    for label in mermaid_parity_items(edge, "labels") {
      if mermaid_parity_text(label, "text") != "" {
        out.push("\{id} label: \{n(f(label, "x"))}, \{n(f(label, "y"))}")
      }
    }
  }
  for child in mermaid_parity_items(node, "children") {
    mermaid_parity_edges(child, out)
  }
}

///|
fn mermaid_parity_layout(input : String) -> String raise {
  let result = @all.new_elk_engine().layout(graph=@json.parse(input))
  let out = []
  mermaid_parity_nodes(result, 0, out)
  mermaid_parity_edges(result, out)
  out.join("\n")
}

///|
test "mermaid flowchart: basic" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "A",
    #|"width": 152, "height": 45}, {"id": "B", "width": 171, "height": 171}, {"id": "C",
    #|"width": 152, "height": 45}, {"id": "D", "width": 152, "height": 45}], "edges": [{"id": "L_A_B_0",
    #|"sources": ["A"], "targets": ["B"], "labels": [{"width": 0, "height": 0, "text": "",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_C_0", "sources": ["B"], "targets": ["C"], "labels": [{"width": 22.84375,
    #|"height": 21, "text": "Yes", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_D_0", "sources": ["B"], "targets": ["D"], "labels": [{"width": 17.90625,
    #|"height": 21, "text": "No", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 368, "height": 426}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 368x426
      #|A: 108, 12 152x45
      #|B: 98.5, 97 171x171
      #|C: 12, 369 152x45
      #|D: 204, 369 152x45
      #|L_A_B_0: 184,57 184,97
      #|L_B_C_0: 158.83333333333331,268 158.83333333333331,288 88,288 88,369
      #|L_B_C_0 label: 76.5, 308
      #|L_B_D_0: 209.16666666666666,268 209.16666666666666,288 280,288 280,369
      #|L_B_D_0 label: 271, 308
    ),
  )
}

///|
test "mermaid flowchart: long edge" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "A",
    #|"width": 152, "height": 45}, {"id": "B", "width": 152, "height": 45}, {"id": "C",
    #|"width": 152, "height": 45}, {"id": "D", "width": 152, "height": 45}], "edges": [{"id": "L_A_B_0",
    #|"sources": ["A"], "targets": ["B"], "labels": [{"width": 0, "height": 0, "text": "",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_C_0", "sources": ["B"], "targets": ["C"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_D_0", "sources": ["C"], "targets": ["D"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_D_0", "sources": ["A"], "targets": ["D"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 224, "height": 324}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 224x324
      #|A: 60, 12 152x45
      #|B: 12, 97 152x45
      #|C: 12, 182 152x45
      #|D: 60, 267 152x45
      #|L_A_B_0: 114,57 114,77 88,77 88,97
      #|L_B_C_0: 88,142 88,182
      #|L_C_D_0: 88,227 88,247 114,247 114,267
      #|L_A_D_0: 158,57 158,77 184,77 184,119.5 184,204.5 184,247 158,247 158,267
    ),
  )
}

///|
test "mermaid flowchart: self loop" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "A",
    #|"width": 152, "height": 45}, {"id": "B", "width": 152, "height": 45}], "edges": [{"id": "L_A_A_0",
    #|"sources": ["A"], "targets": ["A"], "labels": [{"width": 0, "height": 0, "text": "",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_B_0", "sources": ["A"], "targets": ["B"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 196, "height": 154}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 196x154
      #|A: 32, 12 152x45
      #|B: 32, 97 152x45
      #|L_A_A_0: 32,31 12,31 12,38 32,38
      #|L_A_B_0: 108,57 108,97
    ),
  )
}

///|
test "mermaid flowchart: back edges" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "RIGHT", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "A",
    #|"width": 152, "height": 45}, {"id": "B", "width": 152, "height": 45}, {"id": "C",
    #|"width": 152, "height": 45}, {"id": "D", "width": 152, "height": 45}], "edges": [{"id": "L_A_B_0",
    #|"sources": ["A"], "targets": ["B"], "labels": [{"width": 0, "height": 0, "text": "",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_C_0", "sources": ["B"], "targets": ["C"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_D_0", "sources": ["C"], "targets": ["D"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_B_0", "sources": ["D"], "targets": ["B"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_A_0", "sources": ["C"], "targets": ["A"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 752, "height": 108.33333333333334}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 752x108.33333333333334
      #|A: 12, 33.75 152x45
      #|B: 204, 12 152x45
      #|C: 396, 51.33333333333334 152x45
      #|D: 588, 29.583333333333332 152x45
      #|L_A_B_0: 164,52.08333333333334 184,52.08333333333334 184,34.5 204,34.5
      #|L_B_C_0: 356,38.66666666666667 376,38.66666666666667 376,69.66666666666667 396,69.66666666666667
      #|L_C_D_0: 548,73.83333333333334 568,73.83333333333334 568,56.25 588,56.25
      #|L_D_B_0: 588,47.91666666666667 568,47.91666666666667 568,30.333333333333336 472,30.333333333333336 356,30.333333333333336
      #|L_C_A_0: 396,78.00000000000001 280,78 184,78 184,60.41666666666667 164,60.41666666666667
    ),
  )
}

///|
test "mermaid flowchart: g40" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "LEFT", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "B",
    #|"width": 152, "height": 45}, {"id": "C", "width": 152, "height": 45}, {"id": "D",
    #|"width": 152, "height": 45}, {"id": "F", "width": 152, "height": 45}, {"id": "A",
    #|"width": 152, "height": 45}, {"id": "E", "width": 152, "height": 45}], "edges": [{"id": "L_B_C_0",
    #|"sources": ["B"], "targets": ["C"], "labels": [{"width": 0, "height": 0, "text": "",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_F_0", "sources": ["D"], "targets": ["F"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_F_0", "sources": ["C"], "targets": ["F"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_C_0", "sources": ["D"], "targets": ["C"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_C_0", "sources": ["A"], "targets": ["C"], "labels": [{"width": 7, "height": 21,
    #|"text": "x", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_D_0", "sources": ["C"], "targets": ["D"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_E_0", "sources": ["C"], "targets": ["E"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 964, "height": 175.33333333333334}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 964x175.33333333333334
      #|B: 608, 91.25 152x45
      #|C: 416, 35.000000000000014 152x45
      #|D: 204, 33.33333333333334 152x45
      #|F: 12, 12 152x45
      #|A: 800, 17.750000000000014 152x45
      #|E: 204, 118.33333333333334 152x45
      #|L_B_C_0: 608,113.75 588,113.75 588,61.666666666666686 568,61.666666666666686
      #|L_D_F_0: 204,55.83333333333334 184,55.83333333333334 184,38.66666666666667 164,38.66666666666667
      #|L_C_F_0: 416,50.000000000000014 396,50.000000000000014 396,12.333333333333343 280,12.333333333333343 184,12.333333333333343 184,30.33333333333333 164,30.33333333333333
      #|L_D_C_0: 356,60.000000000000014 416,60.000000000000014
      #|L_A_C_0: 800,40.250000000000014 588,40.250000000000014 588,53.33333333333335 568,53.33333333333335
      #|L_A_C_0 label: 680.5, 29.250000000000014
      #|L_C_D_0: 416,55.000000000000014 376,55.000000000000014 376,51.66666666666668 356,51.66666666666668
      #|L_C_E_0: 416,65.00000000000001 396,65.00000000000001 396,140.83333333333334 356,140.83333333333334
    ),
  )
}

///|
test "mermaid flowchart: g05" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "UP", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "G",
    #|"width": 152, "height": 45}, {"id": "H", "width": 152, "height": 45}, {"id": "D",
    #|"width": 152, "height": 45}, {"id": "A", "width": 152, "height": 45}, {"id": "B",
    #|"width": 152, "height": 45}, {"id": "C", "width": 152, "height": 45}], "edges": [{"id": "L_G_H_0",
    #|"sources": ["G"], "targets": ["H"], "labels": [{"width": 7, "height": 21, "text": "x",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_G_0", "sources": ["D"], "targets": ["G"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_B_0", "sources": ["A"], "targets": ["B"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_D_0", "sources": ["B"], "targets": ["D"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_H_0", "sources": ["C"], "targets": ["H"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_H_G_0", "sources": ["H"], "targets": ["G"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_H_0", "sources": ["A"], "targets": ["H"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_G_0", "sources": ["A"], "targets": ["G"], "labels": [{"width": 7, "height": 21,
    #|"text": "x", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 329.7, "height": 514}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 329.7x514
      #|G: 165.7, 202 152x45
      #|H: 87.25, 12 152x45
      #|D: 105.95, 287 152x45
      #|A: 84.45, 457 152x45
      #|B: 105.95, 372 152x45
      #|C: 33, 117 152x45
      #|L_G_H_0: 219.7,202 219.7,182 228.5,182 228.5,97 176.45,97 176.45,57
      #|L_G_H_0 label: 225, 129
      #|L_D_G_0: 181.95,287 181.95,267 219.7,267 219.7,247
      #|L_A_B_0: 160.45,457 160.45,437 181.95,437 181.95,417
      #|L_B_D_0: 181.95,372 181.95,332
      #|L_C_H_0: 109,117 109,97 150.05,97 150.05,57
      #|L_H_G_0: 202.85000000000002,57 202.85000000000002,77 253.45,77 253.45,139.5 253.45,182 263.7,182 263.7,202
      #|L_A_H_0: 127.45,457 127.45,437 12,437 12,394.5 12,309.5 12,224.5 12,139.5 12,77 123.65,77 123.65,57
      #|L_A_G_0: 193.45,457 193.45,437 301.45,437 301.45,309.5 301.45,267 263.7,267 263.7,247
      #|L_A_G_0 label: 297.95, 384
    ),
  )
}

///|
test "mermaid flowchart: subgraph simple" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "three",
    #|"children": [{"id": "c1", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "c2", "width": 152, "height": 45}], "labels": [{"text": "three", "width": 31.921875,
    #|"height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(39.921875, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 244.00000000000003, "height": 222}, {"id": "two", "children": [{"id": "b1",
    #|"width": 152, "height": 45}, {"id": "b2", "width": 152, "height": 45}], "labels": [{"text": "two",
    #|"width": 21.796875, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(29.796875, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "width": 200,
    #|"height": 186}, {"id": "one", "children": [{"id": "a2", "width": 152, "height": 45,
    #|"layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}, {"id": "a1", "width": 152,
    #|"height": 45}], "labels": [{"text": "one", "width": 23.359375, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(31.359375, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 244.00000000000003, "height": 222}], "edges": [{"id": "L_c1_a2_0", "sources": ["c1"],
    #|"targets": ["a2"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a1_a2_0", "sources": ["a1"], "targets": ["a2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b1_b2_0", "sources": ["b1"], "targets": ["b2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_c1_c2_0", "sources": ["c1"], "targets": ["c2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}], "width": 508, "height": 528}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 508x528
      #|three: 12, 12 244.00000000000003x222
      #|  c1: 68.00000000000001, 48 152x45
      #|  c2: 24, 153 152x45
      #|two: 296, 35 200x186
      #|  b1: 24, 48 152x45
      #|  b2: 24, 117 152x45
      #|one: 12, 294 244.00000000000003x222
      #|  a2: 68.00000000000001, 153 152x45
      #|  a1: 24, 48 152x45
      #|L_c1_a2_0: 177.73333333333332,105 177.73333333333332,135 200,135 200,244 200,284 200,417 177.73333333333332,417 177.73333333333332,447
      #|L_a1_a2_0: 99.99999999999999,93 99.99999999999999,123 122.26666666666668,123 122.26666666666668,153
      #|L_b1_b2_0: 99.99999999999999,93 99.99999999999999,117
      #|L_c1_c2_0: 122.26666666666668,93 122.26666666666668,123 99.99999999999999,123 99.99999999999999,153
    ),
  )
}

///|
test "mermaid flowchart: nested subgraphs" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "RIGHT", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "outer",
    #|"children": [{"id": "inner2", "children": [{"id": "c", "width": 152, "height": 45},
    #|{"id": "d", "width": 152, "height": 45}], "labels": [{"text": "inner2", "width": 38.921875,
    #|"height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(46.921875, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "width": 376,
    #|"height": 117}, {"id": "inner1", "children": [{"id": "a", "width": 152, "height": 45},
    #|{"id": "b", "width": 152, "height": 45}], "labels": [{"text": "inner1", "width": 38.921875,
    #|"height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(46.921875, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "width": 376,
    #|"height": 117}], "labels": [{"text": "outer", "width": 31.921875, "height": 19}],
    #|"layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]", "nodeSize.minimum": "(39.921875, 0)",
    #|"spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30, "elk.spacing.edgeEdge": 20,
    #|"spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]", "nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]",
    #|"elk.layered.mergeEdges": false, "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION", "elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]",
    #|"elk.algorithm": "elk.layered", "elk.direction": "DOWN", "elk.hierarchyHandling": "SEPARATE_CHILDREN"},
    #|"width": 424, "height": 330}, {"id": "x", "width": 152, "height": 45}, {"id": "y",
    #|"width": 152, "height": 45}], "edges": [{"id": "L_a_b_0", "sources": ["a"], "targets": ["b"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_c_d_0", "sources": ["c"], "targets": ["d"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_inner1_inner2_0", "sources": ["inner1"],
    #|"targets": ["inner2"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_x_outer_0", "sources": ["x"], "targets": ["outer"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_outer_y_0", "sources": ["outer"],
    #|"targets": ["y"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}], "width": 832, "height": 354}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 832x354
      #|outer: 204, 12 424x330
      #|  inner2: 24, 189 376x117
      #|    c: 24, 48 152x45
      #|    d: 200, 48 152x45
      #|  inner1: 24, 48 376x117
      #|    a: 24, 48 152x45
      #|    b: 200, 48 152x45
      #|x: 12, 154.5 152x45
      #|y: 668, 154.5 152x45
      #|L_a_b_0: 176,70.5 200,70.5
      #|L_c_d_0: 176,70.5 200,70.5
      #|L_inner1_inner2_0: 212,165 212,189
      #|L_x_outer_0: 164,177 204,177
      #|L_outer_y_0: 628,177 668,177
    ),
  )
}

///|
test "mermaid flowchart: g45" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "S1",
    #|"children": [{"id": "B", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "A", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "C", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}],
    #|"labels": [{"text": "S1", "width": 17.125, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(25.125, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 604, "height": 117}, {"id": "D", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "F", "width": 152, "height": 45}, {"id": "G", "width": 152, "height": 45,
    #|"layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}, {"id": "E", "width": 152,
    #|"height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}], "edges": [{"id": "L_B_D_0",
    #|"sources": ["B"], "targets": ["D"], "labels": [{"width": 0, "height": 0, "text": "",
    #|"layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_F_0", "sources": ["D"], "targets": ["F"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_G_0", "sources": ["D"], "targets": ["G"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_E_G_0", "sources": ["E"], "targets": ["G"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_E_0", "sources": ["B"], "targets": ["E"], "labels": [{"width": 15.578125,
    #|"height": 21, "text": "no", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_G_A_0", "sources": ["A"], "targets": ["G"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_D_E_0", "sources": ["D"], "targets": ["E"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_C_D_0", "sources": ["C"], "targets": ["D"], "labels": [{"width": 21.796875,
    #|"height": 21, "text": "yes", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 717, "height": 547}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 717x547
      #|S1: 101, 12 604x117
      #|  B: 24, 48 152x45
      #|  A: 226, 48 152x45
      #|  C: 428, 48 152x45
      #|D: 76.5, 280 152x45
      #|F: 12, 385 152x45
      #|G: 359.5, 490 152x45
      #|E: 335.2651041666667, 385 152x45
      #|L_B_D_0: 179.26666666666665,105 179.26666666666665,139 179.26666666666665,159 136.49999999999997,159 136.49999999999997,229.5 136.49999999999997,260 130.5,260 130.5,280
      #|L_D_F_0: 119.5,325 119.5,345 88,345 88,385
      #|L_D_G_0: 152.5,325 152.5,365 184,365 184,407.5 184,470 402.5,470 402.5,490
      #|L_E_G_0: 411.2651041666667,430 411.2651041666667,450 435.5,450 435.5,490
      #|L_B_E_0: 222.7333333333333,105 222.7333333333333,139 222.7333333333333,179 433.2651041666667,179 433.2651041666667,302.5 433.2651041666667,385
      #|L_B_E_0 label: 425.2651041666667, 219
      #|L_G_A_0: 403,105 403,139 403,159 560.3984375,159 560.3984375,229.5 560.3984375,302.5 560.3984375,407.5 560.3984375,450 468.5,450 468.5,490
      #|L_D_E_0: 185.5,325 185.5,345 389.2651041666667,345 389.2651041666667,385
      #|L_C_D_0: 605,105 605,139 605,199 361,199 361,260 174.5,260 174.5,280
      #|L_C_D_0 label: 350, 219
    ),
  )
}

///|
test "mermaid flowchart: g24" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "UP", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "S2",
    #|"children": [{"id": "D", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "E", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}],
    #|"labels": [{"text": "S2", "width": 17.125, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(25.125, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 402, "height": 117}, {"id": "S1", "children": [{"id": "A", "width": 152,
    #|"height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}, {"id": "B",
    #|"width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "C", "width": 152, "height": 45}], "labels": [{"text": "S1", "width": 17.125,
    #|"height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(25.125, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 402, "height": 222}, {"id": "F", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}],
    #|"edges": [{"id": "L_A_D_0", "sources": ["A"], "targets": ["D"], "labels": [{"width": 0,
    #|"height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_C_0", "sources": ["B"], "targets": ["C"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_F_0", "sources": ["A"], "targets": ["F"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_B_E_0", "sources": ["B"], "targets": ["E"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_C_0", "sources": ["A"], "targets": ["C"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_F_A_0", "sources": ["A"], "targets": ["F"], "labels": [{"width": 0, "height": 0,
    #|"text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_A_E_0", "sources": ["A"], "targets": ["E"], "labels": [{"width": 7, "height": 21,
    #|"text": "x", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]},
    #|{"id": "L_S1_S2_0", "sources": ["S1"], "targets": ["S2"], "labels": [{"width": 0,
    #|"height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true", "edgeLabels.placement": "CENTER"}}]}],
    #|"width": 516.5, "height": 548}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 516.5x548
      #|S2: 12, 12 402x117
      #|  D: 24, 48 152x45
      #|  E: 226, 48 152x45
      #|S1: 102.5, 314 402x222
      #|  A: 24, 153 152x45
      #|  B: 226, 153 152x45
      #|  C: 171.13333333333333, 48 152x45
      #|F: 69.56666666666666, 179 152x45
      #|L_A_D_0: 180.76666666666665,467 180.76666666666665,437 178.5,437 178.5,304 178.5,284 48.56666666666666,284 48.56666666666666,201.5 48.56666666666666,159 111.99999999999999,159 111.99999999999999,139 111.99999999999999,105
      #|L_B_C_0: 280.26666666666665,153 280.26666666666665,123 268.8666666666666,123 268.8666666666666,93
      #|L_A_F_0: 202.5,467 202.5,304 202.5,264 167.56666666666666,264 167.56666666666666,224
      #|L_B_E_0: 426.2333333333333,467 426.2333333333333,437 437.6333333333333,437 437.6333333333333,304 437.6333333333333,284 361.7,284 361.7,201.5 361.7,159 335.7333333333333,159 335.7333333333333,139 335.7333333333333,105
      #|L_A_C_0: 143.46666666666664,153 143.46666666666664,123 225.39999999999998,123 225.39999999999998,93
      #|L_F_A_0: 159.03333333333333,467 159.03333333333333,437 157.5,437 157.5,304 157.5,264 123.56666666666666,264 123.56666666666666,224
      #|L_A_E_0: 224.23333333333332,467 224.23333333333332,304 224.23333333333332,284 298.8833333333333,284 298.8833333333333,159 292.26666666666665,159 292.26666666666665,139 292.26666666666665,105
      #|L_A_E_0 label: 295.3833333333333, 191
      #|L_S1_S2_0: 190.5,314 190.5,244 241.56666666666666,244 241.56666666666666,201.5 241.56666666666666,159 202.13333333333333,159 202.13333333333333,129
    ),
  )
}

///|
test "mermaid flowchart: crossing subgraph" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "right",
    #|"children": [{"id": "b1", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "b2", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "b3", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}],
    #|"labels": [{"text": "right", "width": 27.234375, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(35.234375, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 435.1333333333333, "height": 234}, {"id": "left", "children": [{"id": "a1",
    #|"width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "a2", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}},
    #|{"id": "a3", "width": 152, "height": 45, "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN"}}],
    #|"labels": [{"text": "left", "width": 18.6875, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(26.6875, 0)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=24,left=24,bottom=24,right=24]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.hierarchyHandling": "INCLUDE_CHILDREN"},
    #|"width": 427, "height": 222}], "edges": [{"id": "L_a1_a2_0", "sources": ["a1"], "targets": ["a2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a1_a3_0", "sources": ["a1"], "targets": ["a3"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b1_b2_0", "sources": ["b1"], "targets": ["b2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b1_b3_0", "sources": ["b1"], "targets": ["b3"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a2_b3_0", "sources": ["a2"], "targets": ["b3"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a3_b2_0", "sources": ["a3"], "targets": ["b2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b2_a2_0", "sources": ["a2"], "targets": ["b2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a1_b1_0", "sources": ["a1"], "targets": ["b1"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}], "width": 491.73333333333335, "height": 560}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 491.73333333333335x560
      #|right: 12, 314 435.1333333333333x234
      #|  b1: 24, 48 152x45
      #|  b2: 259.1333333333333, 165 152x45
      #|  b3: 57.133333333333354, 165 152x45
      #|left: 52.73333333333335, 12 427x222
      #|  a1: 49, 48 152x45
      #|  a2: 49, 153 152x45
      #|  a3: 251, 153 152x45
      #|L_a1_a2_0: 124.99999999999999,93 124.99999999999999,153
      #|L_a1_a3_0: 157.59999999999997,93 157.59999999999997,123 327,123 327,153
      #|L_b1_b2_0: 121.7333333333333,93 121.7333333333333,135 302.5333333333333,135 302.5333333333333,165
      #|L_b1_b3_0: 78.26666666666665,93 78.26666666666665,123 111.4,123 111.4,165
      #|L_a2_b3_0: 155.99999999999997,210 156,244 156,284 200,284 199.99999999999997,304 199.99999999999997,437 166.86666666666662,437 166.86666666666662,479
      #|L_a3_b2_0: 379.7333333333333,210 379.73333333333335,244 379.7333333333333,304 379.7333333333333,479
      #|L_b2_a2_0: 199.46666666666664,210 199.46666666666664,244 199.46666666666664,264 347.1333333333333,264 347.1333333333333,304 347.1333333333333,479
      #|L_a1_b1_0: 145.13333333333333,105 145.13333333333333,135 88.73333333333332,135 88.73333333333335,244 88.73333333333335,264 112,264 111.99999999999997,304 111.99999999999994,362
    ),
  )
}
