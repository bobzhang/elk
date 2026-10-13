///|
/// Shared debug representation for the linear-segments node placer.
///
/// The placement phase owns the algorithm, while the layered facade owns the
/// debug exporters that expose this type. Keeping the data record here avoids
/// making the shared package depend on the concrete placement phase.
pub(all) struct LinearSegment {
  nodes : Array[LNode]
  mut id : Int32
  mut index_in_last_layer : Int32
  mut last_layer : Int32
  mut deflection : Double
  mut weight : Int32
  mut ref_segment_id : Int32
  mut _node_type : NodeType
}
