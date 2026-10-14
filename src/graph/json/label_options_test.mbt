///|
test "graph json import edge label options given by their suffix" {
  // ELK resolves an option id by its suffix, so a label's
  // "edgeLabels.inline" is org.eclipse.elk.edgeLabels.inline
  let graph = @core_json.parse(
    (
      #|{"id": "root", "children": [{"id": "a"}, {"id": "b"}],
      #| "edges": [{"id": "e", "sources": ["a"], "targets": ["b"],
      #|  "labels": [{"text": "L", "layoutOptions":
      #|   {"edgeLabels.inline": "true", "edgeLabels.placement": "HEAD"}}]}]}
    ),
  )
  let root = elk_graph_json_for_json_graph(graph).to_elk()
  let label = @graph.edge_labels(@graph.node_contained_edges(root)[0])[0]
  assert_eq(
    @graph.label_layout_option_string_value(
      label,
      @core.edge_labels_inline.get_id(),
    ),
    Some("true"),
  )
  assert_eq(
    @graph.label_layout_option_string_value(
      label,
      @core.edge_labels_placement.get_id(),
    ),
    Some("HEAD"),
  )
}
