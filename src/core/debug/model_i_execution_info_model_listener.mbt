///|
pub(all) struct IExecutionInfoModelListener {
  id : Int32
  execution_info_changed_fn : () -> Unit
}

///|
let execution_info_model_listener_id_ref : Ref[Int32] = Ref(0)

///|
pub fn new_execution_info_model_listener(
  execution_info_changed_fn : () -> Unit,
) -> IExecutionInfoModelListener {
  execution_info_model_listener_id_ref.val = execution_info_model_listener_id_ref.val +
    1
  { id: execution_info_model_listener_id_ref.val, execution_info_changed_fn, }
}

///|
pub fn IExecutionInfoModelListener::get_id(
  self : IExecutionInfoModelListener,
) -> Int32 {
  self.id
}

///|
pub fn IExecutionInfoModelListener::execution_info_changed(
  self : IExecutionInfoModelListener,
) -> Unit {
  (self.execution_info_changed_fn)()
}
