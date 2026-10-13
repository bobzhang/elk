///|
pub struct FailIfNotExecuted {
  marker : Int32
}

///|
pub fn new_fail_if_not_executed() -> FailIfNotExecuted {
  { marker: 0, }
}
