///|
pub(all) enum MrtreeOrderWeighting {
  MODEL_ORDER
  DESCENDANTS
  FAN
  CONSTRAINT
}

///|
pub fn mrtree_order_weighting_from_string(
  value : String,
) -> MrtreeOrderWeighting {
  if value == "DESCENDANTS" {
    DESCENDANTS
  } else if value == "FAN" {
    FAN
  } else if value == "CONSTRAINT" {
    CONSTRAINT
  } else {
    MODEL_ORDER
  }
}
