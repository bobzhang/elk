// Graphs from mermaid diagrams that use layout options beyond the default
// flowchart's, with the layout elkjs 0.9.3 computes for them (helpers in
// mermaid_parity_test.mbt).

///|
test "mermaid state diagram: linear segments node placement" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "LINEAR_SEGMENTS", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": true, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "root_start",
    #|"width": 14, "height": 14}, {"id": "A", "width": 136, "height": 37}, {"id": "B",
    #|"width": 136, "height": 37}, {"id": "C", "width": 136, "height": 37}, {"id": "D",
    #|"width": 136, "height": 37}, {"id": "E", "width": 136, "height": 37}, {"id": "root_end",
    #|"width": 14.013293266296387, "height": 14}], "edges": [{"id": "edge0", "sources": ["root_start"],
    #|"targets": ["A"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge1", "sources": ["A"], "targets": ["B"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge2", "sources": ["A"], "targets": ["C"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge3", "sources": ["A"], "targets": ["D"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge4", "sources": ["B"], "targets": ["E"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge5", "sources": ["C"], "targets": ["E"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge6", "sources": ["D"], "targets": ["E"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "edge7", "sources": ["E"], "targets": ["root_end"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 511.9999999999999x323
      #|root_start: 244.6818052854304, 12 14x14
      #|A: 186.6818052854304, 66 136x37
      #|B: 12, 143 136x37
      #|C: 188, 143 136x37
      #|D: 363.99999999999994, 143 136x37
      #|E: 188, 220 136x37
      #|root_end: 246, 297 14.013293266296387x14
      #|edge0: 254.6818052854304,26 254.6818052854304,66
      #|edge1: 254.6818052854304,103 254.6818052854304,123 80,123 80,143
      #|edge2: 254.6818052854304,103 254.6818052854304,123 256,123 256,143
      #|edge3: 254.6818052854304,103 254.6818052854304,123 431.9999999999999,123 431.9999999999999,143
      #|edge4: 80,180 80,200 256,200 256,220
      #|edge5: 256,180 256,220
      #|edge6: 431.9999999999999,180 431.9999999999999,200 256,200 256,220
      #|edge7: 256,257 256,297
    ),
  )
}

///|
test "enum set options given as strings: node size constraints of child nodes" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.algorithm": "elk.layered"}, "children": [{"id": "n",
    #|"width": 10, "height": 10, "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE]",
    #|"nodeSize.minimum": "(100, 50)"}}, {"id": "m", "width": 10, "height": 10, "layoutOptions": {"elk.nodeSize.constraints": "MINIMUM_SIZE",
    #|"elk.nodeSize.minimum": "(100, 50)"}}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 124x144
      #|n: 12, 12 100x50
      #|m: 12, 82 100x50
    ),
  )
}

///|
test "mermaid agentflow: radial container" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.radial",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": []}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 48.5625x73
      #|t: 12, 12 24.5625x49
      #|  a: 15, 34 150x51
      #|  b: 90, 59.5 150x51
    ),
  )
}

///|
test "mermaid agentflow: force container keeps its size" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.force",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": []}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 204x225
      #|t: 12, 12 180x201
      #|  a: 15, 34 150x51
      #|  b: 15, 135 150x51
    ),
  )
}

///|
test "mermaid agentflow: stress container keeps its size" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.stress",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": []}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 204x225
      #|t: 12, 12 180x201
      #|  a: 15, 34 150x51
      #|  b: 15, 135 150x51
    ),
  )
}

///|
test "mermaid agentflow: fixed container keeps its size" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.fixed",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": []}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 204x124
      #|t: 12, 12 180x100
      #|  a: 0, 0 150x51
      #|  b: 0, 0 150x51
    ),
  )
}

///|
test "mermaid agentflow: rectpacking container keeps its size" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "tools",
    #|"children": [{"id": "a", "width": 164, "height": 33}, {"id": "b", "width": 164, "height": 33}],
    #|"labels": [{"text": "", "width": 0, "height": 0}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(16, 20)", "spacing.baseValue": 15, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 15, "elk.padding": "[top=10,left=10,bottom=10,right=10]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.rectpacking",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "1.6", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.rectpacking.trybox": "true", "elk.rectpacking.packing.compaction.rowHeightReevaluation": "true",
    #|"elk.rectpacking.packing.compaction.iterations": 10, "elk.rectpacking.whiteSpaceElimination.strategy": "EQUAL_BETWEEN_STRUCTURES",
    #|"elk.rectpacking.widthApproximation.strategy": "SCANLINE"}}], "edges": []}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 208x125
      #|tools: 12, 12 184x101
      #|  a: 10, 10 164x33
      #|  b: 10, 58 164x33
    ),
  )
}

///|
test "mermaid agentflow: mrtree container with two nodes" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": []}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 204x225
      #|t: 12, 12 180x201
      #|  a: 115, 65.5 150x51
      #|  b: 115, 166.5 150x51
    ),
  )
}

///|
test "mermaid agentflow: mrtree container with a tree" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51},
    #|{"id": "c", "width": 150, "height": 51}, {"id": "d", "width": 150, "height": 51},
    #|{"id": "e", "width": 150, "height": 51}, {"id": "f", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "L_a_b_0", "sources": ["a"], "targets": ["b"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a_c_0", "sources": ["a"], "targets": ["c"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b_d_0", "sources": ["b"], "targets": ["d"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b_e_0", "sources": ["b"], "targets": ["e"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_c_f_0", "sources": ["c"], "targets": ["f"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 604x326
      #|t: 12, 12 580x302
      #|  a: 290, 40 150x51
      #|  b: 140, 141 150x51
      #|  c: 440, 141 150x51
      #|  d: 40, 242 150x51
      #|  e: 240, 242 150x51
      #|  f: 440, 242 150x51
      #|L_a_b_0: 340,91 340,94 218.5,139.67924528301887 215,141
      #|L_a_c_0: 390,91 390,94 511.5,139.67924528301887 515,141
      #|L_b_d_0: 190,192 190,195 115,242
      #|L_b_e_0: 240,192 240,195 315,242
      #|L_c_f_0: 515,192 515,195 515,242
    ),
  )
}

///|
test "mermaid agentflow: mrtree container with a cycle and two components" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "RIGHT", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51},
    #|{"id": "c", "width": 150, "height": 51}, {"id": "d", "width": 150, "height": 51},
    #|{"id": "x", "width": 150, "height": 51}, {"id": "y", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "L_a_b_0", "sources": ["a"], "targets": ["b"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a_c_0", "sources": ["a"], "targets": ["c"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_c_a_0", "sources": ["c"], "targets": ["a"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b_d_0", "sources": ["b"], "targets": ["d"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_x_y_0", "sources": ["x"], "targets": ["y"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 604x326
      #|t: 12, 12 580x302
      #|  a: 215, 65.5 150x51
      #|  b: 115, 166.5 150x51
      #|  c: 315, 166.5 150x51
      #|  d: 115, 267.5 150x51
      #|  x: 515, 65.5 150x51
      #|  y: 515, 166.5 150x51
      #|L_a_b_0: 265,116.5 265,119.5 190,166.5
      #|L_a_c_0: 315,116.5 315,119.5 390,166.5
      #|L_c_a_0: 390,217.5 390,220.5 468,220.5 468,55.5 290,55.5 290,65.5
      #|L_b_d_0: 190,217.5 190,220.5 190,267.5
      #|L_x_y_0: 590,116.5 590,119.5 590,166.5
    ),
  )
}

///|
test "mermaid agentflow: mrtree container with a multi-level edge" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "root", "width": 150, "height": 51}, {"id": "l1", "width": 150,
    #|"height": 51}, {"id": "m1", "width": 150, "height": 72}, {"id": "r1", "width": 150,
    #|"height": 51}, {"id": "l2", "width": 150, "height": 51}, {"id": "m2", "width": 150,
    #|"height": 51}, {"id": "m3", "width": 150, "height": 51}], "labels": [{"text": "Tree",
    #|"width": 28.28125, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(44.28125, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "L_root_l1_0", "sources": ["root"],
    #|"targets": ["l1"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_root_m1_0", "sources": ["root"],
    #|"targets": ["m1"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_root_r1_0", "sources": ["root"],
    #|"targets": ["r1"], "labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_l1_l2_0", "sources": ["l1"], "targets": ["l2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_m1_m2_0", "sources": ["m1"], "targets": ["m2"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_m1_m3_0", "sources": ["m1"], "targets": ["m3"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_r1_m3_0", "sources": ["r1"], "targets": ["m3"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 704x347
      #|t: 12, 12 680x323
      #|  root: 290, 40 150x51
      #|  l1: 40, 152 150x51
      #|  m1: 340, 141.5 150x72
      #|  r1: 540, 152 150x51
      #|  l2: 40, 263 150x51
      #|  m2: 240, 263 150x51
      #|  m3: 440, 263 150x51
      #|L_root_l1_0: 327.5,91 327.5,94 115,138.5 115,152
      #|L_root_m1_0: 365,91 365,94 415,141.5
      #|L_root_r1_0: 402.5,91 402.5,94 615,138.5 615,152
      #|L_l1_l2_0: 115,203 115,216.5 115,263
      #|L_m1_m2_0: 390,213.5 390,216.5 315,263
      #|L_m1_m3_0: 440,213.5 440,216.5 490,263
      #|L_r1_m3_0: 615,203 615,216.5 543.5,261.6792452830189 540,263
    ),
  )
}

///|
test "mrtree: middle-to-middle edge routing, upwards" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 90.5, "height": 51}, {"id": "n1", "width": 60,
    #|"height": 30}, {"id": "n2", "width": 60, "height": 44.25}, {"id": "n3", "width": 60,
    #|"height": 30}, {"id": "n4", "width": 90.5, "height": 44.25}], "labels": [{"text": "T",
    #|"width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "UP", "elk.mrtree.weighting": "FAN",
    #|"elk.mrtree.edgeRoutingMode": "MIDDLE_TO_MIDDLE"}}], "edges": [{"id": "e0", "sources": ["n0"],
    #|"targets": ["n1"]}, {"id": "e1", "sources": ["n0"], "targets": ["n2"]}, {"id": "e2",
    #|"sources": ["n1"], "targets": ["n3"]}, {"id": "e3", "sources": ["n0"], "targets": ["n4"]},
    #|{"id": "e4", "sources": ["n4"], "targets": ["n3"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 365x288
      #|t: 12, 12 341x264
      #|  n0: 149.75, 214.5 90.5x51
      #|  n1: 40, 127 60x30
      #|  n2: 291, 119.875 60x44.25
      #|  n3: 40, 40 60x30
      #|  n4: 149.75, 119.875 90.5x44.25
      #|e0: 162.47448979591837,214.5 162.47448979591837,214.5 89.13265306122449,157 89.13265306122449,157
      #|e1: 227.78571428571428,214.5 227.78571428571428,214.5 292.55357142857144,164.125 292.55357142857144,164.125
      #|e2: 70,127 70,127 70,70 70,70
      #|e3: 195,214.5 195,214.5 195,164.125 195,164.125
      #|e4: 163.21120689655174,119.875 163.21120689655174,119.875 91.55172413793103,70 91.55172413793103,70
    ),
  )
}

///|
test "mrtree: compaction upwards, two parents" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 150, "height": 51}, {"id": "n1", "width": 150,
    #|"height": 30}, {"id": "n2", "width": 60, "height": 44.25}, {"id": "n3", "width": 90.5,
    #|"height": 44.25}, {"id": "n4", "width": 60, "height": 44.25}, {"id": "n5", "width": 120,
    #|"height": 30}, {"id": "n6", "width": 90.5, "height": 44.25}, {"id": "n7", "width": 90.5,
    #|"height": 30}], "labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "UP", "elk.mrtree.compaction": "true"}}],
    #|"edges": [{"id": "e0", "sources": ["n0"], "targets": ["n1"]}, {"id": "e1", "sources": ["n0"],
    #|"targets": ["n2"]}, {"id": "e2", "sources": ["n2"], "targets": ["n3"]}, {"id": "e3",
    #|"sources": ["n0"], "targets": ["n4"]}, {"id": "e4", "sources": ["n4"], "targets": ["n6"]},
    #|{"id": "e5", "sources": ["n4"], "targets": ["n7"]}, {"id": "e6", "sources": ["n1"],
    #|"targets": ["n5"]}, {"id": "e7", "sources": ["n4"], "targets": ["n5"]}, {"id": "e8",
    #|"sources": ["n1"], "targets": ["n2"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 580x403.25
      #|t: 12, 12 556x379.25
      #|  n0: 228, 322.625 150x51
      #|  n1: 95, 228 150x30
      #|  n2: 210, 40 60x44.25
      #|  n3: 194.75, 40 90.5x44.25
      #|  n4: 406, 228 60x44.25
      #|  n5: 40, 148 120x30
      #|  n6: 319.75, 40 90.5x44.25
      #|  n7: 460.75, 148 90.5x30
      #|e0: 265.5,322.625 265.5,319.625 170,275.25 170,258
      #|e1: 303,322.625 303,319.625 325.5,275.25 325.5,225 235.1875,181 235.1875,145 230,84.25
      #|e2: 240,62.125 240,62.125
      #|e3: 340.5,322.625 340.5,319.625 432.5,273.5707547169811 436,272.25
      #|e4: 436,228 436,225 385.5625,181 385.5625,145 365,84.25
      #|e5: 451,228 451,225 506,178
      #|e6: 145,228 145,225 80,178
      #|e7: 421,228 421,225 123.5,179.32075471698113 120,178
      #|e8: 195,228 195,225 310.375,181 310.375,145 250,84.25
    ),
  )
}

///|
test "mrtree: compaction leftwards, three components" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 150, "height": 44.25}, {"id": "n1", "width": 90.5,
    #|"height": 51}, {"id": "n2", "width": 90.5, "height": 30}, {"id": "n3", "width": 150,
    #|"height": 30}, {"id": "n4", "width": 150, "height": 30}, {"id": "n5", "width": 150,
    #|"height": 44.25}, {"id": "n6", "width": 90.5, "height": 30}, {"id": "n7", "width": 60,
    #|"height": 30}, {"id": "n8", "width": 120, "height": 51}], "labels": [{"text": "T",
    #|"width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "LEFT", "elk.mrtree.compaction": "true"}}],
    #|"edges": [{"id": "e0", "sources": ["n1"], "targets": ["n2"]}, {"id": "e1", "sources": ["n2"],
    #|"targets": ["n3"]}, {"id": "e2", "sources": ["n2"], "targets": ["n4"]}, {"id": "e3",
    #|"sources": ["n3"], "targets": ["n6"]}, {"id": "e4", "sources": ["n1"], "targets": ["n8"]},
    #|{"id": "e5", "sources": ["n7"], "targets": ["n0"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 685.25x331.625
      #|t: 12, 12 661.25x307.625
      #|  n0: 115, 283.625 150x44.25
      #|  n1: 626, 136.625 90.5x51
      #|  n2: 485.5, 102.125 90.5x30
      #|  n3: 256.25, 62.125 150x30
      #|  n4: 256.25, 142.125 150x30
      #|  n5: 425, 283.625 150x44.25
      #|  n6: 115, 62.125 90.5x30
      #|  n7: 315, 290.75 60x30
      #|  n8: 256.25, 182.625 120x51
      #|e0: 626,153.625 623,153.625 576,117.125
      #|e1: 485.5,112.125 482.5,112.125 406.25,77.125
      #|e2: 485.5,122.125 482.5,122.125 406.25,157.125
      #|e3: 256.25,77.125 253.25,77.125 205.5,77.125
      #|e4: 626,170.625 623,170.625 409.25,208.125 376.25,208.125
      #|e5: 315,305.75 312,305.75 265,305.75
    ),
  )
}

///|
test "mrtree: compaction upwards, cycle" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 120, "height": 44.25}, {"id": "n1", "width": 120,
    #|"height": 51}, {"id": "n2", "width": 150, "height": 51}, {"id": "n3", "width": 60,
    #|"height": 51}, {"id": "n4", "width": 60, "height": 44.25}, {"id": "n5", "width": 150,
    #|"height": 51}, {"id": "n6", "width": 90.5, "height": 51}, {"id": "n7", "width": 120,
    #|"height": 51}, {"id": "n8", "width": 120, "height": 44.25}], "labels": [{"text": "T",
    #|"width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "UP", "elk.mrtree.compaction": "true"}}],
    #|"edges": [{"id": "e0", "sources": ["n0"], "targets": ["n1"]}, {"id": "e1", "sources": ["n0"],
    #|"targets": ["n2"]}, {"id": "e2", "sources": ["n2"], "targets": ["n3"]}, {"id": "e3",
    #|"sources": ["n0"], "targets": ["n4"]}, {"id": "e4", "sources": ["n4"], "targets": ["n7"]},
    #|{"id": "e5", "sources": ["n1"], "targets": ["n8"]}, {"id": "e6", "sources": ["n4"],
    #|"targets": ["n2"]}, {"id": "e7", "sources": ["n7"], "targets": ["n0"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 684.25x420.625
      #|t: 12, 12 660.25x396.625
      #|  n0: 285, 267.875 120x44.25
      #|  n1: 115, 166.5 120x51
      #|  n2: 285, 166.5 150x51
      #|  n3: 330, 65.5 60x51
      #|  n4: 485, 166.5 60x44.25
      #|  n5: 115, 362.125 150x51
      #|  n6: 625, 65.5 90.5x51
      #|  n7: 455, 65.5 120x51
      #|  n8: 115, 72.25 120x44.25
      #|e0: 315,267.875 315,264.875 178.5,218.82075471698113 175,217.5
      #|e1: 345,267.875 345,264.875 360,217.5
      #|e2: 360,166.5 360,163.5 360,116.5
      #|e3: 375,267.875 375,264.875 511.5,212.07075471698113 515,210.75
      #|e4: 515,166.5 515,163.5 515,116.5
      #|e5: 175,166.5 175,163.5 175,116.5
      #|e6: 485,189.27822580645162 435,190.36693548387098
      #|e7: 515,65.5 515,62.5 578,62.5 578,322.125 345,322.125 345,315.125 345,312.125
    ),
  )
}

///|
test "mrtree: a cycle of siblings fails instead of looping" {
  // BFS treeifying keeps both edges n0 -> n1, so n1 is its own right
  // sibling; ELK's NodePlacer.secondWalk recurses until the stack overflows
  // (elkjs: "Maximum call stack size exceeded").
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 150, "height": 30}, {"id": "n1", "width": 60,
    #|"height": 51}], "labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.mrtree",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "LEFT", "elk.mrtree.compaction": "true",
    #|"elk.mrtree.searchOrder": "BFS"}}], "edges": [{"id": "e0", "sources": ["n0"], "targets": ["n1"]},
    #|{"id": "e1", "sources": ["n1"], "targets": ["n0"]}, {"id": "e2", "sources": ["n0"],
    #|"targets": ["n1"]}]}
  let message = try mermaid_parity_layout(input) catch {
    error => error.to_string()
  } noraise {
    _ => "no error"
  }
  assert_true(message.contains("StackOverflowError"))
}

///|
test "mermaid agentflow: radial container with a tree" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51},
    #|{"id": "c", "width": 150, "height": 51}, {"id": "d", "width": 150, "height": 51},
    #|{"id": "e", "width": 150, "height": 51}], "labels": [{"text": "T", "width": 8.5625,
    #|"height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.radial",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "L_a_b_0", "sources": ["a"], "targets": ["b"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a_c_0", "sources": ["a"], "targets": ["c"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_b_d_0", "sources": ["b"], "targets": ["d"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}, {"id": "L_a_e_0", "sources": ["a"], "targets": ["e"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 48.5625x73
      #|t: 12, 12 24.5625x49
      #|  a: 173.43295111813072, 171.20696046483945 150x51
      #|  b: 252.6494266771961, 308.41392092967885 150x51
      #|  c: 15, 171.20696046483948 150x51
      #|  d: 331.8659022362615, 445.62088139451816 150x51
      #|  e: 252.64942667719598, 34 150x51
      #|L_a_b_0: 263.15538298246616,222.20696046483945 312.9269948128606,308.41392092967885
      #|L_a_c_0: 173.43295111813072,196.70696046483945 165,196.70696046483945
      #|L_b_d_0: 342.37185854153154,359.41392092967885 392.143470371926,445.62088139451816
      #|L_a_e_0: 263.1553829824661,171.20696046483945 312.92699481286047,85
    ),
  )
}

///|
test "radial: positions from V8's sin and cos, upwards" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 120, "height": 44.25}, {"id": "n1", "width": 120,
    #|"height": 30}, {"id": "n2", "width": 120, "height": 51}, {"id": "n3", "width": 90.5,
    #|"height": 51}, {"id": "n4", "width": 150, "height": 51}, {"id": "n5", "width": 120,
    #|"height": 51}, {"id": "n6", "width": 90.5, "height": 44.25}, {"id": "n7", "width": 120,
    #|"height": 44.25}, {"id": "n8", "width": 90.5, "height": 30}], "labels": [{"text": "T",
    #|"width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.radial",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "UP"}}], "edges": [{"id": "e0", "sources": ["n0"],
    #|"targets": ["n1"]}, {"id": "e1", "sources": ["n1"], "targets": ["n2"]}, {"id": "e2",
    #|"sources": ["n1"], "targets": ["n3"]}, {"id": "e3", "sources": ["n0"], "targets": ["n4"]},
    #|{"id": "e4", "sources": ["n1"], "targets": ["n7"]}, {"id": "e5", "sources": ["n5"],
    #|"targets": ["n8"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 48.5625x73
      #|t: 12, 12 24.5625x49
      #|  n0: 299.2602569388485, 174.00037973184155 120x44.25
      #|  n1: 207.8867701542571, 310.55445649910473 120x30
      #|  n2: 522.9965562812785, 395.0046754713428 120x51
      #|  n3: 127.39561773066745, 426.70930432141904 90.5x51
      #|  n4: 375.63374372343986, 41.196302964578365 150x51
      #|  n5: 359.2602569388485, 196.12537973184155 120x51
      #|  n6: 359.2602569388485, 196.12537973184155 90.5x44.25
      #|  n7: 15, 34 120x44.25
      #|  n8: 359.2602569388485, 196.12537973184155 90.5x30
      #|e0: 343.64059522446917,218.25037973184155 278.4763713165481,310.55445649910473
      #|e1: 317.6670323070733,340.55445649910473 522.9965562812785,402.42522066178066
      #|e2: 256.60716016761,340.55445649910473 191.82095470796753,426.70930432141904
      #|e3: 374.87991865322783,174.00037973184155 432.63142174754506,92.19630296457836
      #|e4: 257.1481464346807,310.55445649910473 90.83946998637515,78.25
    ),
  )
}

///|
test "radial: positions from V8's sin and cos, two parents" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 90.5, "height": 30}, {"id": "n1", "width": 120,
    #|"height": 30}, {"id": "n2", "width": 150, "height": 51}, {"id": "n3", "width": 120,
    #|"height": 30}, {"id": "n4", "width": 60, "height": 44.25}, {"id": "n5", "width": 90.5,
    #|"height": 51}, {"id": "n6", "width": 90.5, "height": 51}], "labels": [{"text": "T",
    #|"width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.radial",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "e0", "sources": ["n0"], "targets": ["n1"]},
    #|{"id": "e1", "sources": ["n1"], "targets": ["n2"]}, {"id": "e2", "sources": ["n2"],
    #|"targets": ["n3"]}, {"id": "e3", "sources": ["n2"], "targets": ["n4"]}, {"id": "e4",
    #|"sources": ["n2"], "targets": ["n5"]}, {"id": "e5", "sources": ["n5"], "targets": ["n6"]},
    #|{"id": "e6", "sources": ["n0"], "targets": ["n2"]}, {"id": "e7", "sources": ["n5"],
    #|"targets": ["n4"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 48.5625x73
      #|t: 12, 12 24.5625x49
      #|  n0: 305.3887488996107, 457.9581233494159 90.5x30
      #|  n1: 290.6387488996107, 616.3910744675467 120x30
      #|  n2: 275.6387488996106, 289.0251722312852 150x51
      #|  n3: 15, 301.66583273641936 120x30
      #|  n4: 773.1522146033503, 305.435175094324 60x44.25
      #|  n5: 538.5087614047766, 232.84437782133642 90.5x51
      #|  n6: 539.8271848191057, 34 90.5x51
      #|e0: 350.6387488996107,487.9581233494159 350.6387488996107,616.3910744675467
      #|e1: 350.6387488996107,616.3910744675467 350.6387488996106,340.0251722312852
      #|e2: 275.6387488996106,315.10763583092785 135,316.19986185670524
      #|e3: 425.6387488996106,316.68560565221674 773.1522146033503,326.6960017259514
      #|e4: 425.6387488996106,296.45053532874647 538.5087614047766,269.24940875253475
      #|e5: 583.9278373295463,232.84437782133642 584.908108894336,85
      #|e6: 350.6387488996107,457.9581233494159 350.6387488996106,340.0251722312852
      #|e7: 629.0087614047766,272.62016764523736 773.1522146033503,318.0955630563786
    ),
  )
}

///|
test "mermaid agentflow: force container with an edge" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.force",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "L_a_b_0", "sources": ["a"], "targets": ["b"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 465.8984045502897x147.39005260791268
      #|t: 12, 12 441.8984045502897x123.39005260791268
      #|  a: 276.8984045502897, 34 150x51
      #|  b: 14.999999999999986, 57.39005260791268 150x51
      #|L_a_b_0: 276.8984045502897,66.19822310909342 165,76.19182949881926
    ),
  )
}

///|
test "mermaid agentflow: stress container with an edge" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "a", "width": 150, "height": 51}, {"id": "b", "width": 150, "height": 51}],
    #|"labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.stress",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true"}}], "edges": [{"id": "L_a_b_0", "sources": ["a"], "targets": ["b"],
    #|"labels": [{"width": 0, "height": 0, "text": "", "layoutOptions": {"edgeLabels.inline": "true",
    #|"edgeLabels.placement": "CENTER"}}]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 303.6035593978055x132.8955581774179
      #|t: 12, 12 279.6035593978055x108.8955581774179
      #|  a: 114.60355939780553, 34 150x51
      #|  b: 15, 42.8955581774179 150x51
      #|L_a_b_0: 114.60355939780553,66.19822310909345 165,61.69733506832445
    ),
  )
}

///|
test "force: labelled edges, inline and not" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 120, "height": 30}, {"id": "n1", "width": 60,
    #|"height": 51}, {"id": "n2", "width": 120, "height": 44.25}, {"id": "n3", "width": 60,
    #|"height": 51}, {"id": "n4", "width": 120, "height": 30}, {"id": "n5", "width": 60,
    #|"height": 51}, {"id": "n6", "width": 150, "height": 44.25}, {"id": "n7", "width": 120,
    #|"height": 30}, {"id": "n8", "width": 60, "height": 44.25}], "labels": [{"text": "T",
    #|"width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.force",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "UP"}}], "edges": [{"id": "e0", "sources": ["n0"],
    #|"targets": ["n1"]}, {"id": "e1", "sources": ["n0"], "targets": ["n2"], "labels": [{"text": "L",
    #|"width": 35.5, "height": 0, "layoutOptions": {"edgeLabels.inline": "false"}}]}, {"id": "e2",
    #|"sources": ["n3"], "targets": ["n4"], "labels": [{"text": "L", "width": 20, "height": 14,
    #|"layoutOptions": {"edgeLabels.inline": "true"}}]}, {"id": "e3", "sources": ["n4"],
    #|"targets": ["n5"]}, {"id": "e4", "sources": ["n4"], "targets": ["n6"]}, {"id": "e5",
    #|"sources": ["n2"], "targets": ["n7"], "labels": [{"text": "L", "width": 0, "height": 0,
    #|"layoutOptions": {"edgeLabels.inline": "false"}}]}, {"id": "e6", "sources": ["n1"],
    #|"targets": ["n8"], "labels": [{"text": "L", "width": 35.5, "height": 14, "layoutOptions": {"edgeLabels.inline": "false"}}]},
    #|{"id": "e7", "sources": ["n4"], "targets": ["n6"], "labels": [{"text": "L", "width": 35.5,
    #|"height": 0, "layoutOptions": {"edgeLabels.inline": "false"}}]}, {"id": "e8", "sources": ["n8"],
    #|"targets": ["n1"], "labels": [{"text": "L", "width": 20, "height": 14, "layoutOptions": {"edgeLabels.inline": "true"}}]},
    #|{"id": "e9", "sources": ["n4"], "targets": ["n5"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 875.8636492025299x536.4010044620834
      #|t: 12, 12 851.8636492025299x512.4010044620834
      #|  n0: 36.30935670348396, 467.40100446208345 120x30
      #|  n1: 70.3240722932731, 188.98235985017533 60x51
      #|  n2: 235.16429511651927, 448.1707628143504 120x44.25
      #|  n3: 612.0921190711023, 34 60x51
      #|  n4: 512.0575219981538, 251.54631746755524 120x30
      #|  n5: 405.1642951165192, 396.32667386458394 60x51
      #|  n6: 686.8636492025299, 102.19894127362551 150x44.25
      #|  n7: 15, 333.10007512388586 120x30
      #|  n8: 167.28121309825553, 34 60x44.25
      #|e0: 96.53412916728195,467.40100446208345 99.94195910481652,239.98235985017533
      #|e1: 156.30935670348396,478.74852037161855 235.16429511651927,473.9482469048153
      #|e1 label: 200.7368259100016, 481.3483836382169
      #|e2: 633.4665987179569,85 577.131357500004,251.5463174675552
      #|e2 label: 597.0748205346281, 156.02315873377762
      #|e3: 558.8337089488439,281.54631746755524 457.64477730034605,396.32667386458394
      #|e4: 592.0761153043396,251.5463174675552 732.3362240759059,146.4489412736255
      #|e5: 255.30089959480392,448.1707628143504 102.02603086217988,363.10007512388586
      #|e5 label: 190.08214755825963, 403.1979189691181
      #|e6: 115.93690577866488,188.98235985017533 183.73478404475384,78.25
      #|e6 label: 153.80264269576338, 140.3036799250869
      #|e7: 592.0761153043396,251.5463174675552 732.3362240759059,146.4489412736255
      #|e7 label: 671.9605856003418, 200.43512937059035
      #|e8: 183.73478404475384,78.25 115.93690577866488,188.98235985017533
      #|e8 label: 138.80264269576526, 128.30367992508843
      #|e9: 558.8337089488439,281.54631746755524 457.64477730034605,396.32667386458394
    ),
  )
}

///|
test "stress: labelled edges, inline and not" {
  let input =
    #|{"id": "root", "layoutOptions": {"elk.hierarchyHandling": "INCLUDE_CHILDREN", "elk.algorithm": "elk.layered",
    #|"elk.layered.nodePlacement.strategy": "BRANDES_KOEPF", "elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED",
    #|"elk.layered.mergeEdges": false, "elk.direction": "DOWN", "spacing.baseValue": 40,
    #|"elk.layered.crossingMinimization.forceNodeModelOrder": false, "elk.layered.considerModelOrder.strategy": "NODES_AND_EDGES",
    #|"elk.layered.unnecessaryBendpoints": true, "elk.layered.cycleBreaking.strategy": "DEPTH_FIRST",
    #|"elk.layered.layering.strategy": "NETWORK_SIMPLEX", "elk.layered.layering.coffmanGraham.layerBound": 4,
    #|"elk.layered.wrapping.multiEdge.improveCuts": true, "elk.layered.wrapping.multiEdge.improveWrappedEdges": true,
    #|"elk.layered.edgeRouting.selfLoopDistribution": "EQUALLY", "elk.layered.mergeHierarchyEdges": true,
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]"}, "children": [{"id": "t",
    #|"children": [{"id": "n0", "width": 120, "height": 44.25}, {"id": "n1", "width": 150,
    #|"height": 51}, {"id": "n2", "width": 60, "height": 44.25}, {"id": "n3", "width": 120,
    #|"height": 51}, {"id": "n4", "width": 120, "height": 30}, {"id": "n5", "width": 90.5,
    #|"height": 44.25}, {"id": "n6", "width": 60, "height": 51}, {"id": "n7", "width": 150,
    #|"height": 51}], "labels": [{"text": "T", "width": 8.5625, "height": 19}], "layoutOptions": {"nodeSize.constraints": "[MINIMUM_SIZE, NODE_LABELS]",
    #|"nodeSize.minimum": "(24.5625, 49)", "spacing.baseValue": 24, "elk.layered.spacing.edgeNodeBetweenLayers": 30,
    #|"elk.spacing.edgeEdge": 20, "spacing.nodeNode": 50, "elk.padding": "[top=34,left=15,bottom=15,right=15]",
    #|"nodeLabels.placement": "[H_CENTER V_TOP, INSIDE]", "elk.layered.mergeEdges": false,
    #|"elk.layered.nodePlacement.bk.fixedAlignment": "BALANCED", "elk.layered.nodePlacement.strategy": "BRANDES_KOEPF",
    #|"elk.layered.cycleBreaking.strategy": "DEPTH_FIRST", "elk.layered.nodePlacement.networkSimplex.nodeFlexibility": "PORT_POSITION",
    #|"elk.spacing.portsSurrounding": "[top=12,left=12,bottom=12,right=12]", "elk.algorithm": "elk.stress",
    #|"elk.hierarchyHandling": "SEPARATE_CHILDREN", "elk.aspectRatio": "2.0", "elk.contentAlignment": "H_CENTER V_TOP",
    #|"elk.expandNodes": "true", "elk.direction": "LEFT"}}], "edges": [{"id": "e0", "sources": ["n0"],
    #|"targets": ["n1"], "labels": [{"text": "L", "width": 20, "height": 14, "layoutOptions": {"edgeLabels.inline": "true"}}]},
    #|{"id": "e1", "sources": ["n0"], "targets": ["n2"], "labels": [{"text": "L", "width": 0,
    #|"height": 14, "layoutOptions": {"edgeLabels.inline": "true"}}]}, {"id": "e2", "sources": ["n3"],
    #|"targets": ["n4"], "labels": [{"text": "L", "width": 35.5, "height": 0, "layoutOptions": {"edgeLabels.inline": "true"}}]},
    #|{"id": "e3", "sources": ["n4"], "targets": ["n5"], "labels": [{"text": "L", "width": 0,
    #|"height": 0, "layoutOptions": {"edgeLabels.inline": "true"}}]}, {"id": "e4", "sources": ["n3"],
    #|"targets": ["n6"]}, {"id": "e5", "sources": ["n3"], "targets": ["n7"]}, {"id": "e6",
    #|"sources": ["n5"], "targets": ["n0"], "labels": [{"text": "L", "width": 0, "height": 0,
    #|"layoutOptions": {"edgeLabels.inline": "false"}}]}, {"id": "e7", "sources": ["n4"],
    #|"targets": ["n2"]}]}
  inspect(
    mermaid_parity_layout(input),
    content=(
      #|root 340.81886849809064x585.6811013411387
      #|t: 12, 12 316.81886849809064x561.6811013411387
      #|  n0: 62.081398714697684, 399.7443235268763 120x44.25
      #|  n1: 15, 495.68110134113874 150x51
      #|  n2: 177.67294972601758, 329.72471238440903 60x44.25
      #|  n3: 116.35834207783057, 116.4981701021513 120x51
      #|  n4: 99.62202424880962, 236.06833707739386 120x30
      #|  n5: 28.150711196784357, 300.37565192662987 90.5x44.25
      #|  n6: 241.81886849809064, 61.98783159344177 60x51
      #|  n7: 28.230294773097, 34 150x51
      #|e0: 114.93420064630556,443.9943235268763 98.2374486211977,495.68110134113874
      #|e0 label: 96.04069935734884, 464.5252124340076
      #|e1: 149.12686548074925,399.7443235268763 180.62748295996602,373.97471238440903
      #|e1 label: 164.37717422035763, 379.8595179556427
      #|e2: 172.44548380984145,167.4981701021513 161.9237055829209,236.06833707739386
      #|e2 label: 150.24018316332013, 196.03325358977256
      #|e3: 141.51649738033223,266.06833707739383 100.10636332778853,300.37565192662987
      #|e3 label: 116.01136772279699, 286.28449450201185
      #|e4: 221.01488779580836,116.4981701021513 241.81886849809064,104.6185788937648
      #|e5: 153.7546260928371,116.4981701021513 125.83401075809047,85
      #|e6: 84.23974319740097,344.62565192662987 111.24236671408107,399.7443235268763
      #|e6 label: 102.74105495574099, 366.1849877267531
      #|e7: 166.77378100904855,266.06833707739383 197.12410850466517,329.72471238440903
    ),
  )
}
