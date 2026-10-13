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
