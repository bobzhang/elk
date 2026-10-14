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
